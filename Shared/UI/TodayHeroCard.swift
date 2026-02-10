//
//  TodayHeroCard.swift
//  DAYFIT
//
//  Created by bella on 2/10/26.
//

import SwiftUI

struct TodayHeroCard: View {
    let locationTitle: String
    let locationSubtitle: String

    let headline: String
    let subline: String

    let temp: String
    let condition: String
    let extra: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 상단: 위치
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(locationTitle)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)

                    Text(locationSubtitle)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.85))
                        .lineLimit(1)
                }

                Spacer()

                // 우측: 온도 + 상태
                VStack(alignment: .trailing, spacing: 2) {
                    Text(temp)
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(.white)

                    Text(condition)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.9))

                    Text(extra)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.75))
                }
            }

            Divider().overlay(.white.opacity(0.25))

            // 하단: 오늘 한 줄 가이드
            VStack(alignment: .leading, spacing: 6) {
                Text(headline)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)

                Text(subline)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(.white.opacity(0.22), lineWidth: 1)
                )
        )
        .shadow(radius: 10, y: 6)
    }
}
