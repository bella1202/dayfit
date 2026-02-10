//
//  LocationNavChip.swift
//  DAYFIT
//
//  Created by bella on 2/10/26.
//
import SwiftUI

struct LocationNavChip: View {
    let title: String
    let subtitle: String
    let isLoading: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "location.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColor.accent)

            VStack(alignment: .leading, spacing: 1) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.primary)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(AppColor.accent)
                }

                HStack(spacing: 6) {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.75)
                    }
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(Color.clear) // 투명
        .contentShape(Rectangle())
    }
}
