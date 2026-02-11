//
//  WeatherViewModel.swift
//  DAYFIT
//
//  Created by bella on 2/11/26.
//

import Foundation

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var tempText: String = "--°"
    @Published var detailText: String = ""
    @Published var summary: String = ""
    @Published var conditionText: String = ""
    @Published var iconStyle: WeatherIconStyle = .sunny

    func apply(_ w: WeatherCurrent) {
        let temp = Int(round(w.main.temp))
        let feels = Int(round(w.main.feels_like))
        tempText = "\(temp)°"

        let first = w.weather.first
        conditionText = first?.description ?? ""

        if let wind = w.wind?.speed {
            detailText = "체감 \(feels)° · 바람 \(String(format: "%.1f", wind))m/s"
        } else {
            detailText = "체감 \(feels)°"
        }

        iconStyle = mapToIconStyle(first?.id)
        summary = makeSummary(temp: temp, feels: feels, weatherId: first?.id)
    }

    private func mapToIconStyle(_ id: Int?) -> WeatherIconStyle {
        guard let id else { return .sunny }
        switch id {
        case 200...232: return .rain
        case 300...321: return .rain
        case 500...531: return .rain
        case 600...622: return .snow
        case 701...781: return .fog
        case 800: return .sunny
        case 801...804: return .cloudy
        default: return .cloudy
        }
    }

    private func makeSummary(temp: Int, feels: Int, weatherId: Int?) -> String {
        if let id = weatherId, (500...531).contains(id) { return "우산 하나 있으면 좋아요" }
        if let id = weatherId, (600...622).contains(id) { return "따뜻한 한 끼가 잘 어울려요" }
        if feels <= 3 { return "따뜻한 쪽이 좋아요" }
        if feels >= 25 { return "가볍게 가도 좋아요" }
        return "무난하게 가도 좋아요"
    }
}
