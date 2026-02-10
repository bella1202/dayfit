//
//  AppColor.swift
//  DAYFIT
//
//  Created by bella on 2/6/26.
//

import SwiftUI

enum AppColor {
    static let pink = Color(red: 1.0, green: 0.44, blue: 0.57)
    
    /// DAYFIT Main Brand Color
    static let primary = Color.pink

    /// Text / Icon on primary background
    static let onPrimary = Color.white

    /// Secondary text
    static let secondaryText = Color.secondary

    /// Disabled state
    static let disabled = Color.gray.opacity(0.4)

    /// Background
    static let background = Color(.systemBackground)
    
    static let gradientTop = Color(red: 1.0, green: 0.372, blue: 0.553)    // #FF5F8D
    static let gradientBottom = Color(red: 1.0, green: 0.561, blue: 0.639) // #FF8FA3
    
    static let surface = Color(.systemBackground)                 // 흰
    static let surface2 = Color(.secondarySystemBackground)       // 아주 연한 그레이(카드용)
    static let stroke = Color.black.opacity(0.06)                 // 카드 테두리
    static let accent = AppColor.pink                             // 포인트 핑크

}
