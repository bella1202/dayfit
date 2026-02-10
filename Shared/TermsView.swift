//
//  TermsView.swift
//  DAYFIT
//
//  Created by bella on 2/6/26.
//

import SwiftUI

struct TermsView: View {
    let title: String
    let content: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                Text(content)
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .padding(24)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(12)
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

