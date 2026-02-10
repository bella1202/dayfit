//
//  TodayActionCard.swift
//  DAYFIT
//
//  Created by bella on 2/10/26.
//

import SwiftUI

struct TodayActionCard: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        Button {
            // TODO: 이동 연결
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .bold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(AppColor.accent)   // 포인트
                    Spacer()
                }

                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Spacer(minLength: 0)
            }
            .padding(14)
            .frame(minHeight: 112)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppColor.surface2)                 // 아주 연한 회색
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .strokeBorder(AppColor.stroke, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
