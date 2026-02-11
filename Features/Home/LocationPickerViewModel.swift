//
//  LocationPickerViewModel.swift
//  DAYFIT
//
//  Created by bella on 2/10/26.
//

import Foundation
import CoreLocation
import MapKit

@MainActor
final class LocationPickerViewModel: NSObject, ObservableObject {
    // 네비바 표시용
    @Published private(set) var navTitle: String = "현재 위치"
    @Published private(set) var navSubtitle: String = "위치를 설정해 주세요"
    @Published private(set) var isResolving: Bool = false
    
    @Published var showPrimaryClearConfirm = false

    // Sheet 상태
    @Published var query: String = ""
    @Published private(set) var suggestions: [MKLocalSearchCompletion] = []
    @Published private(set) var isLocating: Bool = false

    // Alert
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published private(set) var selectedCoordinate: CLLocationCoordinate2D?
    
    @Published private(set) var recents: [LocationItemDTO] = []
    
    private let api: APIClient

    private let manager = CLLocationManager()
    private var pendingCurrentLocationRequest: Bool = false
    
    private let geocoder = CLGeocoder()
    private let completer = MKLocalSearchCompleter()

    // 저장 키
    private let kTitle = "dayfit.loc.title"
    private let kSubtitle = "dayfit.loc.subtitle"
    private let kLat = "dayfit.loc.lat"
    private let kLon = "dayfit.loc.lon"

    private var currentPrimaryId: Int? {
        recents.first(where: { $0.is_primary == true })?.id
    }

    private func isSameLocation(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D) -> Bool {
        abs(a.latitude - b.latitude) < 0.00001 && abs(a.longitude - b.longitude) < 0.00001
    }
    
    init(api: APIClient) {
        self.api = api
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        completer.delegate = self
        completer.resultTypes = [.address, .pointOfInterest]
        completer.region = MKCoordinateRegion(.world)

        // 서버 동기화 목표면 로컬 저장은 "마지막 선택 캐시" 정도만 유지
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
        pendingCurrentLocationRequest = true
        isLocating = true
        isResolving = true

        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            pendingCurrentLocationRequest = false
            isLocating = false
            isResolving = false
            show("위치 권한이 필요해요. 설정에서 위치 권한을 허용해 주세요.")
        @unknown default:
            pendingCurrentLocationRequest = false
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

            Task { @MainActor in
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
    }
    
    func loadRecentsFromServer() {
        Task {
            do {
                let res = try await api.getLocationRecents()
                self.recents = res.items
            } catch {
                self.recents = []
            }
        }
    }

    func deleteRecentFromServer(id: Int) {
        Task {
            do {
                try await api.deleteLocationItem(id: id)
                self.recents.removeAll { $0.id == id }
            } catch { }
        }
    }

    func clearRecentsFromServer() {
        Task {
            do {
                try await api.clearLocationRecents()
                // 서버 정책: 대표(is_primary=true)는 유지
                self.recents.removeAll { $0.is_primary == false }
            } catch { }
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
            self.applySelectionLocalOnly(
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
        selectedCoordinate = coordinate

        // 로컬은 "마지막 선택 캐시"만 (앱 재실행 시 빠르게 보여주려고)
        UserDefaults.standard.set(title, forKey: kTitle)
        UserDefaults.standard.set(subtitle, forKey: kSubtitle)
        UserDefaults.standard.set(coordinate.latitude, forKey: kLat)
        UserDefaults.standard.set(coordinate.longitude, forKey: kLon)
        
        // 서버 대표 저장 + 서버 recents는 DB에서 갱신됨
        Task {
            do {
                try await api.putPrimaryLocation(
                    title: title,
                    subtitle: subtitle,
                    lat: coordinate.latitude,
                    lon: coordinate.longitude
                )
                let r = try await api.getLocationRecents()
                self.recents = r.items
            } catch {
                // 실패해도 UI는 일단 유지
            }
        }
    }

    private func loadSavedIfExists() {
        let title = UserDefaults.standard.string(forKey: kTitle)
        let subtitle = UserDefaults.standard.string(forKey: kSubtitle)

        if let title, let subtitle {
            navTitle = title
            navSubtitle = subtitle
        }
        
        let lat = UserDefaults.standard.object(forKey: kLat) as? Double
        let lon = UserDefaults.standard.object(forKey: kLon) as? Double
        if let lat, let lon {
            selectedCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    }
    
    func requestClearPrimary() {
        showPrimaryClearConfirm = true
    }

    func confirmClearPrimary() {
        Task {
            do {
                try await api.clearPrimaryLocation()
                let r = try await api.getLocationRecents()
                self.recents = r.items
            } catch {
                self.alertMessage = "대표 위치 해제에 실패했어요."
                self.showAlert = true
            }
        }
    }
    
    func applyRecent(_ item: LocationItemDTO, onDone: @escaping () -> Void) {
        let coord = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
        beginSelectAsPrimary(title: item.title, subtitle: item.subtitle, coord: coord, onDone: onDone)
    }

    private func show(_ msg: String) {
        alertMessage = msg
        showAlert = true
    }
    
    func applySelectionLocalOnly(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        navTitle = title
        navSubtitle = subtitle
        selectedCoordinate = coordinate

        UserDefaults.standard.set(title, forKey: kTitle)
        UserDefaults.standard.set(subtitle, forKey: kSubtitle)
        UserDefaults.standard.set(coordinate.latitude, forKey: kLat)
        UserDefaults.standard.set(coordinate.longitude, forKey: kLon)
    }
    
    private func beginSelectAsPrimary(
        title: String,
        subtitle: String,
        coord: CLLocationCoordinate2D,
        onDone: @escaping () -> Void
    ) {
        applySelection(title: title, subtitle: subtitle, coordinate: coord)
        query = ""
        suggestions = []
        onDone()
    }

}

// MARK: - CLLocationManagerDelegate
extension LocationPickerViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if pendingCurrentLocationRequest {
                manager.requestLocation()
            }
        } else if status == .denied || status == .restricted {
            pendingCurrentLocationRequest = false
            isLocating = false
            isResolving = false
            show("위치 권한이 필요해요. 설정에서 위치 권한을 허용해 주세요.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 사용자가 '현위치로 설정'을 눌러서 요청한 경우에만 반영
        guard pendingCurrentLocationRequest else { return }

        pendingCurrentLocationRequest = false
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
        pendingCurrentLocationRequest = false
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
