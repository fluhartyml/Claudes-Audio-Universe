//
//  RecordView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  AVFoundation. Record a clip to temp storage, play it back,
//  share the file via the system share sheet. Nothing persists
//  past the session.
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
