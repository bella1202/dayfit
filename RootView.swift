//
//  RootView.swift
//  DAYFIT
//
//  Created by bella on 2/6/26.
//
import SwiftUI

struct RootView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
            } else {
                if isLoggedIn {
                    HomeView()
                } else {
                    LoginView()
                }
            }
        }
        .onAppear {
            // 스플래시 노출 시간
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}
