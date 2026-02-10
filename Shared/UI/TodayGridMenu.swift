//
//  TodayGridMenu.swift
//  DAYFIT
//
//  Created by bella on 2/10/26.
//

import SwiftUI

struct TodayMenuItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let desc: String
}

struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(.top, 4)
    }
}

struct TodayGridMenu: View {
    let items: [TodayMenuItem]
    let onTap: (TodayMenuItem) -> Void

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10)
        ], spacing: 10) {
            ForEach(items) { item in
                Button {
                    onTap(item)
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: item.icon)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.white)
                            Spacer()
                        }

                        Text(item.title)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.white)

                        Text(item.desc)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.85))
                            .lineLimit(2)

                        Spacer(minLength: 0)
                    }
                    .padding(14)
                    .frame(minHeight: 110)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
