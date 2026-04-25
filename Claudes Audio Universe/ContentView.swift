//
//  ContentView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/23/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  Five sibling tabs because the feature tools are peers, with
//  Under the Hood beside them as a first-class destination rather
//  than hidden behind a settings gear. No programmatic tab-selection
//  state — each tab owns its own session; the shell knows nothing
//  about what's running inside.
//
//  Bible Page (deeper): Reference → ContentView.swift.
//  ────────────────────────────────────────────────────────────────
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

#Preview {
    ContentView()
}
