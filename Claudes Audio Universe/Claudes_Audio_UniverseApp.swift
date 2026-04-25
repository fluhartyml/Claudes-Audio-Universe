//
//  Claudes_Audio_UniverseApp.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/23/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  The Xcode template's SwiftData scaffolding is stripped here
//  because Audio Universe stores nothing — every tab is session-only
//  and outputs leave through the share sheet. Each feature tab also
//  owns its own audio session config, so the entry point stays quiet
//  and the work happens per-tab.
//
//  Bible Page (deeper): Part I → App Entry Point.
//  ────────────────────────────────────────────────────────────────
//

import SwiftUI

@main
struct Claudes_Audio_UniverseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
