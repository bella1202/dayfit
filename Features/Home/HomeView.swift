//
//  HomeView.swift
//  DAYFIT
//
//  Created by bella on 2/10/26.
//

import SwiftUI

struct HomeView: View {
    @State private var showSettings = false
    @State private var showLocationPicker = false

    @StateObject private var locVM = LocationPickerViewModel()

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
                            summary: "DAYFIT 기준, 가벼운 아우터 추천",
                            tempText: "12°",
                            detailText: "체감 10° · 바람 약간",
                            conditionText: "맑음",
                            iconStyle: .sunny
                        )

                        // 섹션 타이틀 (오늘 이렇게 해 ❌)
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
            .onAppear { locVM.bootstrapIfNeeded() }
            .sheet(isPresented: $showSettings) { SettingsView() }
            .sheet(isPresented: $showLocationPicker) {
                LocationPickerSheet(vm: locVM, onClose: { showLocationPicker = false })
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}
