//
//  AppShell.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  Wrapping container that gives every feature view its own
//  NavigationStack with a top-trailing (i) info button. The button
//  presents AboutView as a sheet. Each tab sets its own navigation
//  title on its inner content; AppShell owns only the shared (i)
//  plumbing so the tab body stays feature-focused.
//  ────────────────────────────────────────────────────────────────
//

import SwiftUI

struct AppShell<Content: View>: View {
    let content: () -> Content
    @State private var showAbout = false

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        NavigationStack {
            content()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showAbout = true
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .accessibilityLabel("About")
                    }
                }
                .sheet(isPresented: $showAbout) {
                    AboutView()
                }
        }
    }
}
