//
//  BrandHeader.swift
//  DAYFIT
//
//  Created by bella on 2/10/26.
//

import SwiftUI

struct BrandHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("오늘어때")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(.white)

            Text("DAYFIT")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white.opacity(0.85))
                .tracking(1.2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 4)
    }
}
