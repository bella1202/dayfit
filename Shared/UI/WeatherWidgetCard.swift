//
//  WeatherWidgetCard.swift
//  DAYFIT
//
//  Created by bella on 2/10/26.
//

import SwiftUI

enum WeatherIconStyle {
    case sunny, cloudy, rain, snow, wind, fog

    var systemName: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .cloudy: return "cloud.fill"
        case .rain: return "cloud.rain.fill"
        case .snow: return "cloud.snow.fill"
        case .wind: return "wind"
        case .fog: return "cloud.fog.fill"
        }
    }
}

struct WeatherWidgetCard: View {
    let locationTitle: String
    let locationSubtitle: String
    let summary: String
    let tempText: String
    let detailText: String

    // 추가
    var conditionText: String = "맑음"
    var iconStyle: WeatherIconStyle = .sunny

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("오늘의 날씨")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)

                    Text(locationTitle)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.primary)

                    Text(locationSubtitle)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                // 아이콘 + 온도
                VStack(alignment: .trailing, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: iconStyle.systemName)
                            .font(.system(size: 16, weight: .bold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(AppColor.accent) // 포인트
                        Text(conditionText)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }

                    Text(tempText)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.primary)

                    Text(detailText)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }

            Text("“\(summary)”")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.primary)
                .padding(.top, 2)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AppColor.surface2)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(AppColor.stroke, lineWidth: 1)
                )
        )
    }
}
