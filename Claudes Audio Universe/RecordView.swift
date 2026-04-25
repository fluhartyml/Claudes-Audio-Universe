//
//  RecordView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  AVAudioRecorder over AVAudioEngine because the goal is
//  capture-to-file, not real-time DSP. The session category is
//  .playAndRecord so the same view can play back what it just
//  captured without paying a category-switch cost. Output is .m4a
//  (AAC) — small, portable, accepted everywhere the share sheet
//  sends it.
//  ────────────────────────────────────────────────────────────────
//

import SwiftUI

struct RecordView: View {
    var body: some View {
        PlaceholderTab(
            icon: "mic.circle",
            title: "Record",
            summary: "AVFoundation. Record a clip to temp storage, play it back, share the file."
        )
    }
}
