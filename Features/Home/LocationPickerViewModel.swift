//
//  LocationPickerViewModel.swift
//  DAYFIT
//
//  Created by bella on 2/10/26.
//

import Foundation
import CoreLocation
import MapKit

final class LocationPickerViewModel: NSObject, ObservableObject {
    // 네비바 표시용
    @Published private(set) var navTitle: String = "현재 위치"
    @Published private(set) var navSubtitle: String = "위치를 설정해 주세요"
    @Published private(set) var isResolving: Bool = false

    // Sheet 상태
    @Published var query: String = ""
    @Published private(set) var suggestions: [MKLocalSearchCompletion] = []
    @Published private(set) var isLocating: Bool = false

    // Alert
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()

    private let completer = MKLocalSearchCompleter()

    // 저장 키
    private let kTitle = "dayfit.loc.title"
    private let kSubtitle = "dayfit.loc.subtitle"
    private let kLat = "dayfit.loc.lat"
    private let kLon = "dayfit.loc.lon"

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        completer.delegate = self
        completer.resultTypes = [.address, .pointOfInterest]
        completer.region = MKCoordinateRegion(.world)

        loadSavedIfExists()
    }

    func bootstrapIfNeeded() {
        // 저장된 게 없으면 “현위치” 자동 시작은 취향인데,
        // 푸드앱 느낌 내려면 첫 진입에 한 번 시도하는게 자연스러움.
        if navSubtitle == "위치를 설정해 주세요" {
            // 원치 않으면 이 줄 주석 처리
            useCurrentLocation()
        }
    }

    func useCurrentLocation() {
        isLocating = true
        isResolving = true

        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            isLocating = false
            isResolving = false
            show("위치 권한이 필요해요. 설정에서 위치 권한을 허용해 주세요.")
        @unknown default:
            isLocating = false
            isResolving = false
            show("위치 권한 상태를 확인할 수 없어요.")
        }
    }

    func updateQuery(_ text: String) {
        completer.queryFragment = text
    }

    func selectSuggestion(_ item: MKLocalSearchCompletion, onDone: @escaping () -> Void) {
        isResolving = true

        let request = MKLocalSearch.Request(completion: item)
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self else { return }
            if let error {
                self.isResolving = false
                self.show("검색 실패: \(error.localizedDescription)")
                return
            }
            guard let place = response?.mapItems.first else {
                self.isResolving = false
                self.show("검색 결과를 찾지 못했어요.")
                return
            }

            let coord = place.placemark.coordinate
            let title = item.title.isEmpty ? "선택 위치" : item.title
            let subtitle = item.subtitle.isEmpty ? "주소 정보" : item.subtitle

            self.applySelection(title: title, subtitle: subtitle, coordinate: coord)
            self.query = ""
            self.suggestions = []
            self.isResolving = false
            onDone()
        }
    }

    private func reverseGeocodeAndApply(_ location: CLLocation) {
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let self else { return }
            let pm = placemarks?.first

            // 푸드앱처럼 “구/동 + 도로명 일부” 정도로 깔끔하게
            let title = (pm?.subLocality ?? pm?.locality ?? "현재 위치")
            let subtitle = [
                pm?.thoroughfare,
                pm?.subThoroughfare
            ]
            .compactMap { $0 }
            .joined(separator: " ")

            let cleanSubtitle = subtitle.isEmpty ? (pm?.name ?? "주소 확인 중") : subtitle
            self.applySelection(
                title: title,
                subtitle: cleanSubtitle,
                coordinate: location.coordinate
            )
            self.isResolving = false
        }
    }

    private func applySelection(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        navTitle = title
        navSubtitle = subtitle

        // 저장
        UserDefaults.standard.set(title, forKey: kTitle)
        UserDefaults.standard.set(subtitle, forKey: kSubtitle)
        UserDefaults.standard.set(coordinate.latitude, forKey: kLat)
        UserDefaults.standard.set(coordinate.longitude, forKey: kLon)
    }

    private func loadSavedIfExists() {
        let title = UserDefaults.standard.string(forKey: kTitle)
        let subtitle = UserDefaults.standard.string(forKey: kSubtitle)

        if let title, let subtitle {
            navTitle = title
            navSubtitle = subtitle
        }
    }

    private func show(_ msg: String) {
        alertMessage = msg
        showAlert = true
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationPickerViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        } else if status == .denied || status == .restricted {
            isLocating = false
            isResolving = false
            show("위치 권한이 필요해요. 설정에서 위치 권한을 허용해 주세요.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isLocating = false
        guard let loc = locations.last else {
            isResolving = false
            show("현재 위치를 가져오지 못했어요.")
            return
        }
        reverseGeocodeAndApply(loc)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLocating = false
        isResolving = false
        show("위치 요청 실패: \(error.localizedDescription)")
    }
}

// MARK: - MKLocalSearchCompleterDelegate
extension LocationPickerViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // 너무 많이 뜨면 와꾸 깨져서 상위만
        suggestions = Array(completer.results.prefix(12))
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // 검색 실패는 조용히 처리 (사용자 경험)
        suggestions = []
    }
}
