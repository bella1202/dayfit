//
//  LocationPickerSheet.swift
//  DAYFIT
//
//  Created by bella on 2/10/26.
//
import SwiftUI
import MapKit

struct LocationPickerSheet: View {
    @ObservedObject var vm: LocationPickerViewModel
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            // 커스텀 헤더 (오른쪽 상단 X로 통일)
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("위치설정")
                        .font(.title3)
                        .bold()

                    Text("오늘어때를 이용할 때 사용할 위치를 선택해 주세요.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    onClose()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.black)
                        .padding(10)
                        .background(
                            Circle().fill(Color(.systemBackground).opacity(0.9))
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("닫기")
            }
            .padding(.top, 8)

            // 현위치 버튼
            Button {
                vm.useCurrentLocation()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(AppColor.accent)

                    Text(vm.isLocating ? "현재 위치 가져오는 중..." : "현 위치로 설정")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppColor.accent)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(AppColor.accent.opacity(0.22), lineWidth: 1)
                )

            }
            .buttonStyle(.plain)
            .disabled(vm.isLocating)
            .opacity(vm.isLocating ? 0.7 : 1.0)


            // 주소 검색
            // 주소 검색
            VStack(alignment: .leading, spacing: 10) {
                Text("주소 검색")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)

                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(AppColor.accent.opacity(0.9))

                        TextField("지번/도로명/건물명으로 검색", text: $vm.query)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.primary)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .onChange(of: vm.query) { _, newValue in
                                vm.updateQuery(newValue)
                            }
                    }

                    // underline
                    Rectangle()
                        .fill(Color.black.opacity(0.12))
                        .frame(height: 1)
                }

                if vm.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
                    if vm.suggestions.isEmpty {
                        Text("검색 결과가 없어요.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.top, 6)
                    } else {
                        List {
                            ForEach(vm.suggestions, id: \.self) { item in
                                Button {
                                    vm.selectSuggestion(item) { onClose() }
                                } label: {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.title)
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundStyle(.primary)

                                        if item.subtitle.isEmpty == false {
                                            Text(item.subtitle)
                                                .font(.system(size: 13))
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .padding(.vertical, 6)
                                }
                            }
                        }
                        .listStyle(.plain)
                        .frame(maxHeight: 360)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
            }


            Spacer(minLength: 0)
        }
        .padding(16)
        .alert("위치 설정", isPresented: $vm.showAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(vm.alertMessage)
        }
        .onChange(of: vm.navSubtitle) { _, newValue in
            if newValue != "위치를 설정해 주세요" {
                onClose()
            }
        }
    }
}
