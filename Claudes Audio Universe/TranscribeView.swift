//
//  TranscribeView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  Speech. Tap start, talk, stop, share the resulting text via
//  the system share sheet. The text is plain string output —
//  the user picks where it goes.
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
