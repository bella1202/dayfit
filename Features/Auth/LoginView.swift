//
//  LoginView.swift
//  DAYFIT
//
//  Created by bella on 2026/02/xx.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {

    // MARK: - Dependencies
    @EnvironmentObject private var api: APIClient
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    // MARK: - State
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMsg: String?
    @State private var showSignup: Bool = false

    // MARK: - View
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // MARK: Logo
            if let ui = UIImage(named: "app_logo") {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
            } else {
                Image(systemName: "cloud.sun.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 96)
                    .foregroundColor(AppColor.pink)
            }

            Text("오늘어때")
                .font(.largeTitle)
                .bold()

            Text("A daily guide for your weather-fit day")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Spacer()

            // MARK: Email Field
            VStack(alignment: .leading, spacing: 6) {
                Text("Email")
                    .font(.footnote)
                    .foregroundColor(.secondary)

                TextField("example@email.com", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
            }

            // MARK: Password Field
            VStack(alignment: .leading, spacing: 6) {
                Text("Password")
                    .font(.footnote)
                    .foregroundColor(.secondary)

                SecureField("Enter your password", text: $password)
                    .textInputAutocapitalization(.never)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
            }

            // MARK: Email Login Button
            Button {
                Task { await emailLogin() }
            } label: {
                HStack {
                    Spacer()
                    Text("Log In")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.vertical, 14)
                .background(AppColor.pink)
                .cornerRadius(14)
            }
            .disabled(
                isLoading ||
                email.isEmpty ||
                password.isEmpty ||
                !email.contains("@")
            )
            .opacity(
                (isLoading || email.isEmpty || password.isEmpty) ? 0.5 : 1.0
            )

            // MARK: Apple Login Button
            SignInWithAppleButton(
                .signIn,
                onRequest: { request in
                    request.requestedScopes = [.email]
                },
                onCompletion: { result in
                    handleAppleLogin(result)
                }
            )
            .signInWithAppleButtonStyle(.black)
            .frame(height: 48)
            .cornerRadius(14)

            // MARK: Signup
            Button {
                showSignup = true
            } label: {
                Text("Create an account")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .sheet(isPresented: $showSignup) {
                SignupView()
                    .environmentObject(api)
            }

            // MARK: Error
            if let msg = errorMsg {
                Text(msg)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Spacer(minLength: 40)
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Actions

    @MainActor
    private func emailLogin() async {
        guard email.contains("@") else {
            errorMsg = "Please enter a valid email."
            return
        }

        guard password.count >= 6 else {
            errorMsg = "Password must be at least 6 characters."
            return
        }

        isLoading = true
        errorMsg = nil

        do {
            try await api.loginWithEmail(
                email: email,
                password: password
            )
            isLoggedIn = true
        } catch {
            errorMsg = error.localizedDescription
        }

        isLoading = false
    }

    private func handleAppleLogin(
        _ result: Result<ASAuthorization, Error>
    ) {
        switch result {
        case .success(let auth):
            guard
                let credential = auth.credential
                    as? ASAuthorizationAppleIDCredential,
                let data = credential.identityToken,
                let token = String(data: data, encoding: .utf8)
            else {
                errorMsg = "Apple login failed."
                return
            }

            Task {
                do {
                    try await api.loginWithApple(identityToken: token)
                    isLoggedIn = true
                } catch {
                    errorMsg = error.localizedDescription
                }
            }

        case .failure:
            errorMsg = "Apple login was cancelled."
        }
    }
}
