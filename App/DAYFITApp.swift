//
//  DAYFITApp.swift
//  DAYFIT
//
//  Created by bella on 2/6/26.
//

import SwiftUI

@main
struct DAYFITApp: App {
    @StateObject private var api: APIClient
    @StateObject private var locVM: LocationPickerViewModel

    init() {
        let api = APIClient()
        _api = StateObject(wrappedValue: api)
        _locVM = StateObject(wrappedValue: LocationPickerViewModel(api: api))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(api)
                .environmentObject(locVM)
        }
    }
}

