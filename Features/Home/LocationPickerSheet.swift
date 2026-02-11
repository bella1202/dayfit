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

    @State private var pendingCloseAfterCurrentLocation = false
    @State private var showClearRecentsConfirm = false

    private var trimmedQuery: String {
        vm.query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        VStack(spacing: 14) {
            headerView
            currentLocationButton
            searchSection
            Spacer(minLength: 0)
        }
        .padding(16)
        .alert("위치 설정", isPresented: $vm.showAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(vm.alertMessage)
        }
        .task {
            vm.loadRecentsFromServer()
        }
        .onChange(of: vm.isResolving) { _, resolving in
            guard pendingCloseAfterCurrentLocation else { return }
            if resolving == false, vm.selectedCoordinate != nil {
                pendingCloseAfterCurrentLocation = false
                onClose()
            }
        }
        .confirmationDialog(
            "대표주소를 해제할까요?",
            isPresented: $vm.showPrimaryClearConfirm,
            titleVisibility: .visible
        ) {
            Button("해제", role: .destructive) {
                vm.confirmClearPrimary()
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("대표주소가 없다면 현위치를 기본으로 사용해요.")
        }

        .confirmationDialog(
            "최근 검색 기록을 모두 삭제할까요?",
            isPresented: $showClearRecentsConfirm,
            titleVisibility: .visible
        ) {
            Button("삭제", role: .destructive) {
                vm.clearRecentsFromServer()
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("대표주소를 제외한 나머지 주소가 모두 삭제돼요.")
        }
    }
}

// MARK: - Subviews
private extension LocationPickerSheet {

    var headerView: some View {
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

            Button(action: onClose) {
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
    }

    var currentLocationButton: some View {
        Button {
            pendingCloseAfterCurrentLocation = true
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
    }

    var searchSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("주소 검색")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)

            searchField

            if trimmedQuery.isEmpty {
                recentsSection
            } else {
                suggestionsSection
            }
        }
    }

    var searchField: some View {
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

            Rectangle()
                .fill(Color.black.opacity(0.12))
                .frame(height: 1)
        }
    }

    @ViewBuilder
    var recentsSection: some View {
        if vm.recents.isEmpty == false {
            HStack {
                Text("최근 검색")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)

                Spacer()

                Button("전체삭제") {
                    showClearRecentsConfirm = true
                }
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(AppColor.accent)
                .buttonStyle(.plain)
            }
            .padding(.top, 4)

            List {
                ForEach(vm.recents) { item in
                    Button {
                        vm.applyRecent(item, onDone: { onClose() })
                    } label: {
                        recentRow(item: item)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            vm.deleteRecentFromServer(id: item.id)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .frame(maxHeight: 320)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    @ViewBuilder
    func recentRow(item: LocationItemDTO) -> some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(item.subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            if item.is_primary == true {
                Text("대표")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(AppColor.accent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(AppColor.accent.opacity(0.12))
                    .clipShape(Capsule())
                    .contentShape(Capsule())
                    .highPriorityGesture(
                        TapGesture().onEnded {
                            vm.requestClearPrimary()   // 여기서 알럿/다이얼로그 띄우기
                        }
                    )
            }
        }
        .padding(.vertical, 6)
    }


    @ViewBuilder
    var suggestionsSection: some View {
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

