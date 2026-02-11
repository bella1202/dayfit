//
//  HomeView.swift
//  DAYFIT
//
//  Created by bella on 2/10/26.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @State private var showSettings = false
    @State private var showLocationPicker = false

    @EnvironmentObject private var api: APIClient
    @StateObject private var weatherVM = WeatherViewModel()
    @EnvironmentObject private var locVM: LocationPickerViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                // 완전 흰 배경
                AppColor.surface.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        Spacer().frame(height: 8)

                        // 날씨 카드 (아이콘만 추가한 버전으로 교체)
                        WeatherWidgetCard(
                            locationTitle: locVM.navTitle,
                            locationSubtitle: locVM.navSubtitle,
                            summary: weatherVM.summary.isEmpty ? "DAYFIT 기준으로 오늘을 준비해요" : weatherVM.summary,
                            tempText: weatherVM.tempText,
                            detailText: weatherVM.detailText.isEmpty ? "날씨 불러오는 중" : weatherVM.detailText,
                            conditionText: weatherVM.conditionText,
                            iconStyle: weatherVM.iconStyle
                        )
                        

                        // 섹션 타이틀 (오늘 이렇게 해)
                        HStack {
                            Text("오늘의 추천")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.primary)

                            Spacer()

                            Text("DAYFIT")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(AppColor.accent)
                        }
                        .padding(.top, 6)

                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 10),
                            GridItem(.flexible(), spacing: 10)
                        ], spacing: 10) {

                            TodayActionCard(
                                icon: "tshirt.fill",
                                title: "오늘의 코디",
                                subtitle: "가디건 + 가벼운 아우터"
                            )

                            TodayActionCard(
                                icon: "bowl.fill",
                                title: "오늘의 한 끼",
                                subtitle: "뜨끈한 국물 🍲"
                            )

                            TodayActionCard(
                                icon: "heart.fill",
                                title: "오늘의 데이트",
                                subtitle: "실내 + 따뜻한 카페"
                            )

                            TodayActionCard(
                                icon: "figure.walk",
                                title: "오늘의 갈 곳",
                                subtitle: "가까운 산책 코스"
                            )
                        }

                        Spacer().frame(height: 18)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 6)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { showLocationPicker = true } label: {
                        LocationNavChip(
                            title: locVM.navTitle,
                            subtitle: locVM.navSubtitle,
                            isLoading: locVM.isResolving
                        )
                    }
                    .buttonStyle(.plain)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showSettings = true } label: {
                        Image(systemName: "gearshape")
                            .renderingMode(.template)
                            .foregroundStyle(AppColor.accent) // 설정 아이콘 포인트 핑크
                    }
                }
            }
            .onAppear {
                Task {
                    await syncPrimaryOrFallback()
                    await fetchWeatherIfPossible()
                }
            }
            .onChange(of: showLocationPicker) { _, isShown in
                if isShown {
                    locVM.loadRecentsFromServer()
                }
            }
            .onChange(of: locVM.selectedCoordinate?.latitude) { _, _ in
                Task { await fetchWeatherIfPossible() }
            }
            .onChange(of: locVM.selectedCoordinate?.longitude) { _, _ in
                Task { await fetchWeatherIfPossible() }
            }
            .sheet(isPresented: $showSettings) { SettingsView() }
            .sheet(isPresented: $showLocationPicker) {
                LocationPickerSheet(vm: locVM, onClose: { showLocationPicker = false })
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            
        }
    }
    
    private func fetchWeatherIfPossible() async {
        guard let c = locVM.selectedCoordinate else { return }
        do {
            let w = try await api.fetchCurrentWeather(lat: c.latitude, lon: c.longitude)
            weatherVM.apply(w)
        } catch {
            // 실패해도 UI 깨지지 않게 최소 처리
            weatherVM.detailText = "날씨 정보를 불러오지 못했어요"
        }
    }
    
    private func syncPrimaryOrFallback() async {
        guard api.accessToken != nil else { return }
        
        do {
            let res = try await api.getPrimaryLocation()
            if let item = res.item {
                let coord = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
                locVM.applySelectionLocalOnly(
                    title: item.title,
                    subtitle: item.subtitle,
                    coordinate: coord
                )
                print("HomeView syncPrimary -> [\(locVM.navTitle)] to", item.title, item.lat, item.lon)

                return
            }

            // 대표가 없으면 현위치로
            locVM.useCurrentLocation()
            print("bella")
        } catch {
            print("primary decode/req error:", error)
            // 실패하면 현위치로 (원하면 여기서 유지로 바꿀 수도 있음)
            locVM.useCurrentLocation()
            print("bella2")
        }
        
        // 토큰이 없으면 서버 primary를 못 가져오니까,
        // 여기서 현위치로 강제하지 말고(덮어쓰기 금지) 그냥 로컬 캐시 유지.
        // guard api.accessToken != nil else { return }
    
//        do {
//            let res = try await api.getPrimaryLocation()
//            if let item = res.item {
//                let coord = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
//                locVM.applySelectionLocalOnly(
//                    title: item.title,
//                    subtitle: item.subtitle,
//                    coordinate: coord
//                )
//                return
//            }
//        } catch {
//            // unauthorized든 뭐든 여기로 옴 -> fallback
//        }
        
        

        // 대표 없거나 실패하면 현위치(단, 현위치는 서버에 저장 안 함)
//        locVM.useCurrentLocation()
    }

}
