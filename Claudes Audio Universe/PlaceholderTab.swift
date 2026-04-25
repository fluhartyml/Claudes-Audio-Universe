//
//  PlaceholderTab.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  Shared scaffold body used by every feature tab until its real
//  implementation lands. Replace each feature view's body with the
//  real UI when MusicKit / AVFoundation / ShazamKit / Speech work
//  begins.
//

import SwiftUI

struct PlaceholderTab: View {
    let icon: String
    let title: String
    let summary: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.title)
            Text(summary)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)
        }
    }
}
