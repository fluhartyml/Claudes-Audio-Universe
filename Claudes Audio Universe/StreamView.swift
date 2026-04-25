//
//  StreamView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  ApplicationMusicPlayer rather than SystemMusicPlayer — the
//  latter would hijack the user's actual Music.app queue, which
//  is hostile in a single-session tool. MusicSubscription is
//  checked before any catalog playback so non-subscribers see why
//  nothing happens. Search is term-based against the catalog;
//  this view never touches the user's library.
//  ────────────────────────────────────────────────────────────────
//

import SwiftUI

struct StreamView: View {
    var body: some View {
        AppShell {
            PlaceholderTab(
                icon: "play.circle",
                title: "Stream",
                summary: "MusicKit. Search Apple Music, pick a song, hear it play."
            )
            .navigationTitle("Stream")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}
