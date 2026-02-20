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
    @State private var showLogoutAlert = false
    
    @State private var email: String = ""
    @State private var nickname: String = ""
    @State private var birthday: String = ""
    @State private var phone: String = ""
    @State private var isLoading = true

    var body: some View {
        List {

            // Profile
            Section {
                if isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .padding(.vertical, 20)

                } else {

                    VStack(alignment: .leading, spacing: 16) {

                        // 닉네임 + 이메일
                        VStack(alignment: .leading, spacing: 6) {
                            Text(nickname.isEmpty ? "—" : nickname)
                                .font(.system(size: 17, weight: .semibold))

                            Text(email)
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }

                        Divider()

                        // 상세 정보
                        VStack(spacing: 14) {
                            infoRow(title: "Birthday", value: formatBirthday(birthday))
                            infoRow(title: "Phone", value: formatPhone(phone))
                        }
                    }
                    .padding(.vertical, 8)
                }
            }

            // Account
            Section("Account") {
                Button(role: .destructive) {
                    showLogoutAlert = true
                } label: {
                    HStack {
                        Spacer()
                        Text("Log out")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
            }

            // App
            Section {
                HStack {
                    Spacer()
                    Text(appVersion)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.black)
                }
            }
        }
        .alert("Log out?", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Log out", role: .destructive) {
                api.logout()
                dismiss()
            }
        } message: {
            Text("You’ll need to log in again.")
        }
        .task {
            await loadProfile()
        }
    }

//    // 1.0 (1)
//    private var appVersion: String {
//        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
//        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
//        return "\(version) (\(build))"
//    }
    
    // DAYFIT 1.0
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        return "DAYFIT \(version)"
    }
    
    private func loadProfile() async {
        guard api.accessToken != nil else { return }

        do {
            let me = try await api.getMe()
            email = me.email ?? ""
            nickname = me.nickname ?? ""
            birthday = me.birthday ?? ""
            phone = me.phone ?? ""
            isLoading = false
        } catch {
            isLoading = false
        }
    }
    
    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)

            Spacer()

            Text(value.isEmpty ? "-" : value)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.primary)
        }
    }
    
    private func formatPhone(_ raw: String) -> String {
        let numbers = raw.filter { $0.isNumber }

        if numbers.count == 11 {
            return numbers.replacingOccurrences(
                of: "(\\d{3})(\\d{4})(\\d{4})",
                with: "$1-$2-$3",
                options: .regularExpression
            )
        } else if numbers.count == 10 {
            return numbers.replacingOccurrences(
                of: "(\\d{3})(\\d{3})(\\d{4})",
                with: "$1-$2-$3",
                options: .regularExpression
            )
        }

        return raw
    }
    
    private func formatBirthday(_ raw: String) -> String {
        guard !raw.isEmpty else { return "-" }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        if let date = formatter.date(from: raw) {
            let output = DateFormatter()
            output.dateFormat = "yyyy.MM.dd"
            return output.string(from: date)
        }

        return raw
    }
}
