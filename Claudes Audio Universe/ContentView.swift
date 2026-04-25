//
//  ContentView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/23/26.
//
//  TabView root. Each tab body lives in its own file: StreamView,
//  RecordView, IdentifyView, TranscribeView, UnderTheHoodView.
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
