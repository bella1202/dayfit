//
//  RootView.swift
//  DAYFIT
//
//  Created by bella on 2/6/26.
//
import SwiftUI

struct RootView: View {
    @EnvironmentObject private var api: APIClient
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
            } else {
                if api.accessToken != nil {
                    HomeView()
                } else {
                    LoginView()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}
