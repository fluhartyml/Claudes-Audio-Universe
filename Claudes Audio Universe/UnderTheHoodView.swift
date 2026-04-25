//
//  UnderTheHoodView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  Lists every source file of this app for curious readers, with
//  the file's purpose pulled from DeveloperNotes. Real
//  implementation will read the bundled source list and surface
//  each file's contents inline.
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
