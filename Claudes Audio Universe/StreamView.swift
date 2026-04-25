//
//  StreamView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  MusicKit. Search Apple Music, pick a song, hear it play.
//  Playback only — no output, no share sheet, no storage.
//

import SwiftUI

struct StreamView: View {
    var body: some View {
        PlaceholderTab(
            icon: "play.circle",
            title: "Stream",
            summary: "MusicKit. Search Apple Music, pick a song, hear it play."
        )
    }
}
