//
//  AboutView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  Standard about page — icon, name, version, credit, then four
//  outbound affordances: Send Feedback (mailto via FeedbackView),
//  Support / Wiki (GitHub), Privacy Policy (fluharty.me), and
//  Portfolio (fluharty.me). App icon image is read from the
//  bundle's primary CFBundleIcons entry rather than referenced by
//  static name, so a future icon swap doesn't break this view.
//  ────────────────────────────────────────────────────────────────
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showFeedback = false

    private let supportURL = URL(string: "https://github.com/fluhartyml/Claudes-Audio-Universe/wiki")!
    private let privacyURL = URL(string: "https://fluharty.me/audiouniverse-privacy")!
    private let portfolioURL = URL(string: "https://fluharty.me")!

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let icon = appIcon {
                        Image(uiImage: icon)
                            .resizable()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .shadow(radius: 4)
                    }

                    Text("Claude's Audio Universe")
                        .font(.title)
                        .multilineTextAlignment(.center)

                    Text("Version \(appVersion)")
                        .font(.body)
                        .foregroundStyle(.secondary)

                    Text("A four-tab audio utility — stream, record, identify, and transcribe. Each tab is built on one Apple audio framework.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)

                    Divider().padding(.horizontal, 40)

                    VStack(spacing: 8) {
                        Text("Engineered with Claude by Anthropic")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Text("Companion app for Claude's X26 Swift6 Bible")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 30)

                    VStack(spacing: 12) {
                        Button {
                            showFeedback = true
                        } label: {
                            Label("Send Feedback", systemImage: "envelope")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)

                        Link(destination: supportURL) {
                            Label("Support / Wiki", systemImage: "book")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)

                        Link(destination: privacyURL) {
                            Label("Privacy Policy", systemImage: "hand.raised")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)

                        Link(destination: portfolioURL) {
                            Label("Portfolio", systemImage: "person.crop.circle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.horizontal, 30)
                    .controlSize(.large)

                    Divider().padding(.horizontal, 40)

                    Text("Licensed under GPL v3")
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                    Spacer(minLength: 16)
                }
                .padding(.vertical, 30)
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showFeedback) {
                FeedbackView()
            }
        }
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    #if canImport(UIKit)
    private var appIcon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
              let lastIcon = iconFiles.last else {
            return nil
        }
        return UIImage(named: lastIcon)
    }
    #endif
}
