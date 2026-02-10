//
//  SettingsView.swift
//  DAYFIT
//
//  Created by bella on 2/10/26.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var api: APIClient
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                Button {
                    api.logout()
                    isLoggedIn = false
                    dismiss()
                } label: {
                    Text("로그아웃")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.red)
                        .cornerRadius(14)
                }

                Spacer()
            }
            .padding(24)
            .navigationTitle("설정")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") {
                        dismiss()
                    }
                }
            }
        }
    }
}
