//
//  ContentView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/23/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            StreamView()
                .tabItem {
                    Label("Stream", systemImage: "play.circle")
                }

            RecordView()
                .tabItem {
                    Label("Record", systemImage: "mic.circle")
                }

            IdentifyView()
                .tabItem {
                    Label("Identify", systemImage: "shazam.logo")
                }

            TranscribeView()
                .tabItem {
                    Label("Transcribe", systemImage: "text.bubble")
                }

            UnderTheHoodView()
                .tabItem {
                    Label("Under the Hood", systemImage: "wrench.and.screwdriver")
                }
        }
    }
}

private struct PlaceholderTab: View {
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

struct StreamView: View {
    var body: some View {
        PlaceholderTab(
            icon: "play.circle",
            title: "Stream",
            summary: "MusicKit. Search Apple Music, pick a song, hear it play."
        )
    }
}

struct RecordView: View {
    var body: some View {
        PlaceholderTab(
            icon: "mic.circle",
            title: "Record",
            summary: "AVFoundation. Record a clip to temp storage, play it back, share the file."
        )
    }
}

struct IdentifyView: View {
    var body: some View {
        PlaceholderTab(
            icon: "shazam.logo",
            title: "Identify",
            summary: "ShazamKit. Tap listen, get the match. Auto-saves to My Shazam Tracks; tap the row to open in Apple Music."
        )
    }
}

struct TranscribeView: View {
    var body: some View {
        PlaceholderTab(
            icon: "text.bubble",
            title: "Transcribe",
            summary: "Speech. Tap start, talk, stop, share the resulting text."
        )
    }
}

struct UnderTheHoodView: View {
    var body: some View {
        PlaceholderTab(
            icon: "wrench.and.screwdriver",
            title: "Under the Hood",
            summary: "Browse every source file of this app, in this app."
        )
    }
}

#Preview {
    ContentView()
}
