//
//  SignupView.swift
//  DAYFIT
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject private var api: APIClient
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var isChecking = false
    @State private var errorMsg: String?
    @State private var goDetail = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 24) {
                    Spacer()

                    Text("회원가입")
                        .font(.largeTitle)
                        .bold()

                    Text("이메일을 입력해주세요")
                        .foregroundColor(.secondary)

                    TextField("example@email.com", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)

                    Button {
                        Task { await checkEmail() }
                    } label: {
                        Text("다음")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                    .disabled(isChecking || !email.contains("@"))

                    if let msg = errorMsg {
                        Text(msg)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)

                // X 버튼 (레이아웃 안 흔들림)
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(12)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 8)
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $goDetail) {
                SignupDetailView(email: email)
            }
        }
    }

    @MainActor
    private func checkEmail() async {
        errorMsg = nil
        isChecking = true
        do {
            let exists = try await api.checkEmail(email: email)
            if exists {
                errorMsg = "이미 가입된 이메일입니다."
            } else {
                goDetail = true
            }
        } catch {
            errorMsg = "이메일 확인에 실패했습니다."
        }
        isChecking = false
    }
}
