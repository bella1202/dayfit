//
//  AppConfig.swift
//  DAYFIT
//
//  Created by bella on 2026/02/xx.
//

import Foundation

enum AppConfig {

    /// Local API Server
    static let baseURL: URL = {
        // iOS 시뮬레이터에서 접근 가능한 로컬 IP
        // Mac의 로컬 서버 (Apache)
//        return URL(string: "http://dayfit.api.local")!
        
        // 필요하면 실제 IP로도 가능
        return URL(string: "http://192.168.11.89:8080")!
    }()
}
