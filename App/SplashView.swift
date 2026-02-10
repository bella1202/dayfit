//
//  SplashView.swift
//  DAYFIT
//
//  Created by bella on 2/6/26.
//
import SwiftUI

struct SplashView: View {
    @State private var showLogo = false
    @State private var showText = false
    @State private var pulse = false

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color.pink.opacity(0.95),
                    Color.pink.opacity(0.75),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                // Logo
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 160, height: 160)
                        .scaleEffect(pulse ? 1.05 : 0.95)
                        .animation(
                            Animation.easeInOut(duration: 1.4)
                                .repeatForever(autoreverses: true),
                            value: pulse
                        )

                    Image(systemName: "cloud.sun.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color.white)
                }
                .scaleEffect(showLogo ? 1.0 : 0.6)
                .opacity(showLogo ? 1 : 0)
                .animation(
                    Animation.spring(response: 0.6, dampingFraction: 0.7),
                    value: showLogo
                )

                // App Name
                VStack(spacing: 6) {
                    Text("오늘어때")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(Color.white)
                        .opacity(showText ? 1 : 0)
                        .offset(y: showText ? 0 : 8)
                        .animation(
                            Animation.easeOut(duration: 0.4)
                                .delay(0.2),
                            value: showText
                        )

                    Text("DAYFIT")
                        .font(.system(size: 14, weight: .medium))
                        .tracking(2)
                        .foregroundColor(Color.white.opacity(0.85))
                        .opacity(showText ? 1 : 0)
                        .offset(y: showText ? 0 : 6)
                        .animation(
                            Animation.easeOut(duration: 0.4)
                                .delay(0.35),
                            value: showText
                        )
                }

                Spacer()

                // Footer
                Text("Your day, your fit")
                    .font(.footnote)
                    .foregroundColor(Color.white.opacity(0.7))
                    .opacity(showText ? 1 : 0)
                    .animation(
                        Animation.easeOut(duration: 0.4)
                            .delay(0.5),
                        value: showText
                    )

                Spacer().frame(height: 40)
            }
        }
        .onAppear {
            showLogo = true
            showText = true
            pulse = true
        }
    }
}

