//
//  SignupDetailView.swift
//  DAYFIT
//
//  Created by bella on 2/6/26.
//

import SwiftUI

struct SignupDetailView: View {
    @EnvironmentObject private var api: APIClient
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    let email: String

    // MARK: - Email Verify
    @State private var verifyCode = ""
    @State private var isCodeSent = false
    @State private var isEmailVerified = false
    @State private var showCodeAlert = false

    // MARK: - User Inputs
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var nickname = ""
    @State private var birthday: Date = Date()
    @State private var phone = ""

    @State private var showPassword = false
    @State private var showConfirmPassword = false

    // MARK: - Terms
    @State private var agreedTerms = false
    @State private var showTermsSheet = false
    @State private var showPrivacySheet = false

    // MARK: - UI
    @State private var isLoading = false
    @State private var errorMsg: String?
    @State private var showSuccessAlert = false

    // MARK: - Verify Timer
    @State private var remainSeconds: Int = 0
    @State private var timer: Timer?

    // MARK: - Password Validation
    private var passwordScore: Int {
        var score = 0
        if password.count >= 8 { score += 1 }
        if password.range(of: "[A-Za-z]", options: .regularExpression) != nil { score += 1 }
        if password.range(of: "[0-9]", options: .regularExpression) != nil { score += 1 }
        if password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil { score += 1 }
        return score
    }

    private var passwordStrengthText: String {
        switch passwordScore {
        case 0...1: return "약함"
        case 2...3: return "보통"
        default: return "강함"
        }
    }

    private var passwordStrengthColor: Color {
        switch passwordScore {
        case 0...1: return .red
        case 2...3: return .orange
        default: return .green
        }
    }

    private var isFormValid: Bool {
        isEmailVerified &&
        passwordScore >= 3 &&
        password == confirmPassword &&
        !nickname.isEmpty &&
        phone.filter(\.isNumber).count == 11 &&
        agreedTerms
    }

    // MARK: - View
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {

                    VStack(spacing: 6) {
                        Text("회원정보 입력")
                            .font(.title2)
                            .bold()

                        Text("이메일 인증 후 진행해주세요")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }

                    // Email
                    field("이메일") {
                        HStack {
                            Text(email)
                                .foregroundColor(isEmailVerified ? .green : .primary)
                            Spacer()

                            if isEmailVerified {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Button("인증번호 요청") {
                                    Task { await requestVerifyCode() }
                                }
                                .font(.footnote)
                            }
                        }
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }

                    // Code Input
                    if isCodeSent && !isEmailVerified {
                        field("인증번호") {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    TextField("6자리 인증번호", text: $verifyCode)
                                        .keyboardType(.numberPad)

                                    Button("확인") {
                                        Task { await verifyEmailCode() }
                                    }
                                    .font(.footnote)
                                    .disabled(remainSeconds <= 0)
                                }

                                Text("남은 시간 \(formatTime(remainSeconds))")
                                    .font(.footnote)
                                    .foregroundColor(
                                        remainSeconds > 60 ? .secondary : .red
                                    )
                            }
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        }
                    }

                    if isEmailVerified {
                        Divider()

                        field("비밀번호") {
                            passwordField($password, $showPassword, "영문+숫자+특수문자 8자 이상")
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("보안 강도: \(passwordStrengthText)")
                                .font(.footnote)
                                .foregroundColor(passwordStrengthColor)

                            GeometryReader { geo in
                                Capsule()
                                    .fill(passwordStrengthColor)
                                    .frame(
                                        width: geo.size.width * CGFloat(passwordScore) / 4,
                                        height: 6
                                    )
                            }
                            .frame(height: 6)
                        }

                        field("비밀번호 확인") {
                            passwordField($confirmPassword, $showConfirmPassword, "비밀번호 재입력")
                        }

                        // 비밀번호 불일치 노티
                        if !confirmPassword.isEmpty && password != confirmPassword {
                            Text("비밀번호가 일치하지 않습니다.")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }

                        field("닉네임") {
                            TextField("닉네임 입력", text: $nickname)
                                .padding(12)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                        }

                        field("생년월일") {
                            DatePicker(
                                "",
                                selection: $birthday,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                        }

                        field("휴대폰 번호") {
                            TextField("010-0000-0000", text: $phone)
                                .keyboardType(.numberPad)
                                .onChange(of: phone) { _, v in
                                    phone = formatPhone(v)
                                }
                                .padding(12)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                        }

                        // Terms
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Button {
                                    agreedTerms.toggle()
                                } label: {
                                    Image(systemName: agreedTerms ? "checkmark.square.fill" : "square")
                                }
                                Text("서비스 이용약관 및 개인정보 처리방침 동의")
                                    .font(.footnote)
                            }

                            HStack(spacing: 12) {
                                Button("서비스 이용약관") { showTermsSheet = true }
                                Button("개인정보 처리방침") { showPrivacySheet = true }
                            }
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        }

                        Button {
                            Task { await signup() }
                        } label: {
                            Text("회원가입 완료")
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.pink)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                        }
                        .disabled(!isFormValid || isLoading)
                        .opacity((!isFormValid || isLoading) ? 0.5 : 1)
                    }

                    if let msg = errorMsg {
                        Text(msg)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                }
                .padding(24)
            }

            // X 버튼 (레이아웃 분리 + 여백)
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
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .alert("인증번호가 발송되었습니다", isPresented: $showCodeAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("인증번호는 10분 이내에 입력해주세요.")
        }
        .alert("회원가입 완료", isPresented: $showSuccessAlert) {
            Button("확인") {
                isLoggedIn = true
            }
        }
        .sheet(isPresented: $showTermsSheet) {
            TermsView(
                title: "서비스 이용약관",
                content: LegalText.terms
            )
        }

        .sheet(isPresented: $showPrivacySheet) {
            TermsView(
                title: "개인정보 처리방침",
                content: LegalText.privacy
            )
        }
    }

    // MARK: - Actions
    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }

    @MainActor
    private func requestVerifyCode() async {
        do {
            try await api.requestEmailVerify(email: email)
            remainSeconds = 600
            startTimer()
            isCodeSent = true
            showCodeAlert = true
            errorMsg = nil
        } catch {
            errorMsg = error.localizedDescription
        }
    }

    @MainActor
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainSeconds > 0 {
                remainSeconds -= 1
            } else {
                timer?.invalidate()
                timer = nil
                isCodeSent = false
            }
        }
    }

    @MainActor
    private func verifyEmailCode() async {
        do {
            try await api.verifyEmailCode(email: email, code: verifyCode)
            isEmailVerified = true
            timer?.invalidate()
            timer = nil
        } catch {
            errorMsg = "인증번호가 올바르지 않습니다."
        }
    }

    @MainActor
    private func signup() async {
        isLoading = true
        do {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd"

            try await api.signupWithEmail(
                email: email,
                password: password,
                nickname: nickname,
                birthday: f.string(from: birthday),
                phone: phone.filter(\.isNumber)
            )

            showSuccessAlert = true
        } catch {
            errorMsg = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - UI Helpers
    private func field<Content: View>(
        _ title: String,
        @ViewBuilder _ content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.footnote)
                .foregroundColor(.secondary)
            content()
        }
    }

    private func passwordField(
        _ text: Binding<String>,
        _ visible: Binding<Bool>,
        _ placeholder: String
    ) -> some View {
        HStack {
            if visible.wrappedValue {
                TextField(placeholder, text: text)
            } else {
                SecureField(placeholder, text: text)
            }

            Button {
                visible.wrappedValue.toggle()
            } label: {
                Image(systemName: visible.wrappedValue ? "eye.slash" : "eye")
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func formatPhone(_ input: String) -> String {
        let d = input.filter(\.isNumber)
        let v = String(d.prefix(11))
        if v.count <= 3 { return v }
        if v.count <= 7 { return "\(v.prefix(3))-\(v.dropFirst(3))" }
        return "\(v.prefix(3))-\(v.dropFirst(3).prefix(4))-\(v.dropFirst(7))"
    }
}
