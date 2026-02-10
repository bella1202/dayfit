//
//  APIClient.swift
//  DAYFIT
//
//  Created by bella on 2026/02/xx.
//

import Foundation

@MainActor
final class APIClient: ObservableObject {

    // MARK: - Constants
//    private let baseURL = URL(string: "http://dayfit.api.local")!
    private let baseURL = AppConfig.baseURL

    // MARK: - Published
    @Published var accessToken: String? {
        didSet {
            UserDefaults.standard.set(accessToken, forKey: "accessToken")
        }
    }

    // MARK: - Init
    init() {
        self.accessToken = UserDefaults.standard.string(forKey: "accessToken")
    }

    // MARK: - Public Auth APIs

    /// Email Login
    func loginWithEmail(
        email: String,
        password: String
    ) async throws {

        let url = baseURL.appendingPathComponent("/v1/auth/login")

        let body: [String: Any] = [
            "email": email,
            "password": password
        ]

        let response: LoginResponse = try await request(
            url: url,
            method: "POST",
            body: body
        )

        self.accessToken = response.token
    }

    /// Apple Login
    func loginWithApple(
        identityToken: String
    ) async throws {

        let url = baseURL.appendingPathComponent("/v1/auth/apple")

        let body: [String: Any] = [
            "identityToken": identityToken
        ]

        let response: LoginResponse = try await request(
            url: url,
            method: "POST",
            body: body
        )

        self.accessToken = response.token
    }
    
    /// Email duplication check
    func checkEmail(email: String) async throws -> Bool {
        let url = baseURL.appendingPathComponent("/v1/auth/email/check")

        let body: [String: Any] = [
            "email": email
        ]

        let response: EmailCheckResponse = try await request(
            url: url,
            method: "POST",
            body: body
        )

        return response.exists
    }
    
    // MARK: - Email Verification

    func requestEmailVerify(email: String) async throws {
        let url = baseURL.appendingPathComponent("/v1/auth/email/request")

        let body: [String: Any] = [
            "email": email
        ]

        let _: EmptyResponse = try await request(
            url: url,
            method: "POST",
            body: body
        )
    }

    func verifyEmailCode(
        email: String,
        code: String
    ) async throws {
        let url = baseURL.appendingPathComponent("/v1/auth/email/verify")

        let body: [String: Any] = [
            "email": email,
            "code": code
        ]

        let _: EmptyResponse = try await request(
            url: url,
            method: "POST",
            body: body
        )
    }

    struct SignupResponse: Decodable {
        let token: String
        let user: User
    }

    struct User: Decodable {
        let id: Int
        let email: String
        let nickname: String
    }
    
    // MARK: - Signup (Full)
    func signupWithEmail(
        email: String,
        password: String,
        nickname: String,
        birthday: String,
        phone: String
    ) async throws {

        let url = baseURL.appendingPathComponent("/v1/auth/signup")

        let body: [String: Any] = [
            "email": email,
            "password": password,
            "nickname": nickname,
            "birthday": birthday,
            "phone": phone
        ]

        let response: SignupResponse = try await request(
            url: url,
            method: "POST",
            body: body
        )
    }

    /// Signup (Email)
    func signup(
        email: String,
        password: String
    ) async throws {

        let url = baseURL.appendingPathComponent("/v1/auth/signup")

        let body: [String: Any] = [
            "email": email,
            "password": password
        ]

        let _: EmptyResponse = try await request(
            url: url,
            method: "POST",
            body: body
        )
    }

    /// Logout
    func logout() {
        accessToken = nil
        UserDefaults.standard.removeObject(forKey: "accessToken")
    }

    // MARK: - Core Request

    private func request<T: Decodable>(
        url: URL,
        method: String,
        body: [String: Any]? = nil
    ) async throws -> T {

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 15
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = accessToken {
            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }

        if let body = body {
            request.httpBody = try JSONSerialization.data(
                withJSONObject: body,
                options: []
            )
        }
        
        print("REQUEST:", url.absoluteString)
        if let body = body {
            print("BODY:", body)
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        
        print("RESPONSE RAW:", String(data: data, encoding: .utf8) ?? "")

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200..<300).contains(http.statusCode) else {
            let message = parseErrorMessage(from: data)
            throw APIError.server(
                code: http.statusCode,
                message: message
            )
        }

        do {
            let decoded = try JSONDecoder().decode(APIResponse<T>.self, from: data)
            return decoded.data
        } catch {
            throw APIError.decodingFailed
        }
    }

    // MARK: - Error Parse

    private func parseErrorMessage(from data: Data) -> String {
        guard
            let json = try? JSONSerialization.jsonObject(
                with: data,
                options: []
            ) as? [String: Any],
            let message = json["message"] as? String
        else {
            return "Unknown server error."
        }
        return message
    }
}

// MARK: - Models

private struct LoginResponse: Decodable {
    let token: String
}

private struct EmailCheckResponse: Decodable {
    let exists: Bool
}

private struct EmptyResponse: Decodable { }

private struct APIResponse<T: Decodable>: Decodable {
    let success: Bool
    let data: T
}

// MARK: - Errors

enum APIError: LocalizedError {
    case invalidResponse
    case server(code: Int, message: String)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response."
        case .server(_, let message):
            return message
        case .decodingFailed:
            return "Failed to decode response."
        }
    }
}
