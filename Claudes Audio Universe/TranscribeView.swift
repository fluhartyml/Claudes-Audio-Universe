//
//  TranscribeView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  SFSpeechAudioBufferRecognitionRequest streams the live mic
//  rather than re-transcribing a file. On-device recognition is
//  preferred when supported (no audio leaves the device); cloud
//  fallback runs only when the recognizer doesn't support local
//  for the active locale. The recognizer respects user locale
//  unless explicitly overridden.
//  ────────────────────────────────────────────────────────────────
//

import SwiftUI

struct TranscribeView: View {
    var body: some View {
        PlaceholderTab(
            icon: "text.bubble",
            title: "Transcribe",
            summary: "Speech. Tap start, talk, stop, share the resulting text."
        )
    }
}
