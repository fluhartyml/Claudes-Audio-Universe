//
//  IdentifyView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  ShazamKit. Tap listen, get the match. On iOS 17+ / macOS 14+
//  the song auto-saves to "My Shazam Tracks" via SHLibrary; on
//  any supported OS the match row taps through to Apple Music
//  via the SHMediaItem's appleMusicURL.
//

import SwiftUI

struct IdentifyView: View {
    var body: some View {
        PlaceholderTab(
            icon: "shazam.logo",
            title: "Identify",
            summary: "ShazamKit. Tap listen, get the match. Auto-saves to My Shazam Tracks; tap the row to open in Apple Music."
        )
    }
}
