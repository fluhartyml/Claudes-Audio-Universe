//
//  IdentifyView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  SHManagedSession (iOS 15+ / macOS 12+) over raw SHSession
//  because it owns the audio-buffer plumbing — fewer code paths
//  to maintain. SHLibrary.default.addItems() auto-saves to
//  "My Shazam Tracks" on iOS 17+ / macOS 14+; older OSes still
//  get the tap-through to Apple Music via SHMediaItem.appleMusicURL.
//  ────────────────────────────────────────────────────────────────
//

import SwiftUI

struct IdentifyView: View {
    var body: some View {
        AppShell {
            PlaceholderTab(
                icon: "shazam.logo",
                title: "Identify",
                summary: "ShazamKit. Tap listen, get the match. Auto-saves to My Shazam Tracks; tap the row to open in Apple Music."
            )
            .navigationTitle("Identify")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
