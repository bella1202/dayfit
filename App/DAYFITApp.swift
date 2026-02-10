//
//  DAYFITApp.swift
//  DAYFIT
//
//  Created by bella on 2/6/26.
//

import SwiftUI

@main
struct DAYFITApp: App {
    @StateObject private var api = APIClient()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(api)
        }
    }
}
