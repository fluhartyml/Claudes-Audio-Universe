//
//  PlaceholderTab.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  A single parameterized scaffold so each feature view can be
//  filled in independently without touching the shell. As real
//  implementations land in StreamView, RecordView, IdentifyView,
//  and TranscribeView, this file's call sites shrink; once all
//  feature views ship real bodies, this file is deleted.
//  ────────────────────────────────────────────────────────────────
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
