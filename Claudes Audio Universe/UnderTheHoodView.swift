//
//  UnderTheHoodView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  This view IS the Under the Hood feature — a list of the app's
//  own source files plus each file's UTH callout block (the
//  comment header you're reading right now), surfaced in-app.
//  Phase 1 ships file list and callout extraction; Phase 2 adds
//  inline Lexicon popups so any Swift keyword in the rendered
//  source can be tapped for a definition.
//  ────────────────────────────────────────────────────────────────
//

import SwiftUI

struct UnderTheHoodView: View {
    var body: some View {
        PlaceholderTab(
            icon: "wrench.and.screwdriver",
            title: "Under the Hood",
            summary: "Browse every source file of this app, in this app."
        )
    }
}
