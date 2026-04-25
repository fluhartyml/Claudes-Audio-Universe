//
//  IdentifyView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  SHManagedSession (iOS 15+ / macOS 12+) over raw SHSession
//  because it owns the audio-buffer plumbing — fewer code paths
//  to maintain. SHLibrary.default.addItems() auto-saves to
//  "My Shazam Tracks" on iOS 17+ / macOS 14+; older OSes still
//  get the tap-through to Apple Music via SHMediaItem.appleMusicURL.
//  ────────────────────────────────────────────────────────────────
//

import SwiftUI
import ShazamKit
import AVFoundation

struct IdentifyView: View {
    @State private var permission: AVAudioApplication.recordPermission = AVAudioApplication.shared.recordPermission
    @State private var phase: Phase = .idle
    @State private var matches: [SHMediaItem] = []
    @State private var statusMessage: String?
    @State private var session: SHManagedSession?

    enum Phase { case idle, listening }

    var body: some View {
        AppShell {
            content
                .navigationTitle("Identify")
                .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch permission {
        case .undetermined:
            promptView
        case .denied:
            deniedView
        case .granted:
            mainView
        @unknown default:
            deniedView
        }
    }

    // MARK: Authorized

    private var mainView: some View {
        VStack(spacing: 0) {
            controlArea
                .padding(.top, 24)
            if let statusMessage {
                Text(statusMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 8)
            }
            matchList
        }
    }

    private var controlArea: some View {
        VStack(spacing: 16) {
            Image(systemName: phase == .listening ? "waveform" : "shazam.logo")
                .font(.system(size: 64))
                .foregroundStyle(phase == .listening ? AnyShapeStyle(.tint) : AnyShapeStyle(.secondary))
                .symbolEffect(.variableColor.iterative, isActive: phase == .listening)

            switch phase {
            case .idle:
                Button(action: startListening) {
                    Label("Listen", systemImage: "ear")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal, 32)
            case .listening:
                Button(action: stopListening) {
                    Label("Stop", systemImage: "stop.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .padding(.horizontal, 32)
            }
        }
    }

    @ViewBuilder
    private var matchList: some View {
        if matches.isEmpty {
            Spacer()
            Text("Tap Listen and play a song nearby.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.bottom, 32)
        } else {
            List {
                Section("Matches") {
                    ForEach(matches, id: \.shazamID) { item in
                        row(for: item)
                            .contentShape(Rectangle())
                            .onTapGesture { open(item) }
                    }
                }
            }
            .listStyle(.plain)
        }
    }

    private func row(for item: SHMediaItem) -> some View {
        HStack(spacing: 12) {
            artwork(for: item)
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title ?? "Unknown title")
                    .font(.body)
                    .lineLimit(1)
                Text(item.artist ?? "Unknown artist")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer()
            if item.appleMusicURL != nil {
                Image(systemName: "arrow.up.right.square")
                    .foregroundStyle(.tint)
            }
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private func artwork(for item: SHMediaItem) -> some View {
        if let url = item.artworkURL {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.tertiarySystemBackground))
            }
            .frame(width: 44, height: 44)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        } else {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.tertiarySystemBackground))
                .frame(width: 44, height: 44)
                .overlay(Image(systemName: "music.note").foregroundStyle(.secondary))
        }
    }

    // MARK: Permission states

    private var promptView: some View {
        VStack(spacing: 16) {
            Image(systemName: "mic.circle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Microphone access")
                .font(.title2)
            Text("Identify needs the microphone to listen for songs playing nearby.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button("Continue") {
                Task {
                    let granted = await AVAudioApplication.requestRecordPermission()
                    permission = granted ? .granted : .denied
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var deniedView: some View {
        VStack(spacing: 16) {
            Image(systemName: "mic.slash.circle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Microphone access denied")
                .font(.title2)
            Text("Open Settings → Claude's Audio Universe → Microphone to grant access.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Actions

    private func startListening() {
        statusMessage = nil
        let s = SHManagedSession()
        session = s
        phase = .listening

        Task {
            let result = await s.result()
            await handle(result)
        }
    }

    private func stopListening() {
        session?.cancel()
        session = nil
        phase = .idle
    }

    @MainActor
    private func handle(_ result: SHSession.Result) async {
        phase = .idle
        session = nil

        switch result {
        case .match(let match):
            guard let item = match.mediaItems.first else {
                statusMessage = "Match returned with no media item."
                return
            }
            if !matches.contains(where: { $0.shazamID == item.shazamID }) {
                matches.insert(item, at: 0)
            }
            statusMessage = "Matched: \(item.title ?? "Unknown")"
            await saveToShazamLibrary(item)
        case .noMatch:
            statusMessage = "No match. Move closer to the source and try again."
        case .error(let error, _):
            statusMessage = "Listen error: \(error.localizedDescription)"
        }
    }

    private func saveToShazamLibrary(_ item: SHMediaItem) async {
        do {
            try await SHLibrary.default.addItems([item])
        } catch {
            // Auto-save is best-effort; the row tap-through still works.
        }
    }

    private func open(_ item: SHMediaItem) {
        guard let url = item.appleMusicURL else { return }
        UIApplication.shared.open(url)
    }
}
