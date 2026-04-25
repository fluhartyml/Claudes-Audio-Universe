//
//  StreamView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  ApplicationMusicPlayer rather than SystemMusicPlayer — the
//  latter would hijack the user's actual Music.app queue, which
//  is hostile in a single-session tool. MusicSubscription is
//  checked before any catalog playback so non-subscribers see why
//  nothing happens. Search is term-based against the catalog;
//  this view never touches the user's library.
//  ────────────────────────────────────────────────────────────────
//

import SwiftUI
import MusicKit
import AVFoundation

struct StreamView: View {
    @State private var authStatus: MusicAuthorization.Status = MusicAuthorization.currentStatus
    @State private var hasSubscription = false
    @State private var searchText = ""
    @State private var results: [Song] = []
    @State private var nowPlayingID: MusicItemID?
    @State private var isPlaying = false
    @State private var avPlayer: AVPlayer?
    @State private var statusMessage: String?

    private let player = ApplicationMusicPlayer.shared

    var body: some View {
        AppShell {
            content
                .navigationTitle("Stream")
                .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch authStatus {
        case .authorized:
            authorizedView
        case .notDetermined:
            authorizationPromptView(action: requestAuthorization)
        case .denied, .restricted:
            authorizationDeniedView
        @unknown default:
            authorizationDeniedView
        }
    }

    // MARK: Authorized

    private var authorizedView: some View {
        VStack(spacing: 0) {
            searchField
            if let statusMessage {
                Text(statusMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
            resultsList
        }
        .task {
            await observeSubscription()
        }
    }

    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search Apple Music", text: $searchText)
                .textFieldStyle(.plain)
                .submitLabel(.search)
                .onSubmit { Task { await runSearch() } }
            if !searchText.isEmpty {
                Button { searchText = "" ; results = [] } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }

    private var resultsList: some View {
        List(results, id: \.id) { song in
            row(for: song)
                .contentShape(Rectangle())
                .onTapGesture { Task { await tapped(song) } }
        }
        .listStyle(.plain)
    }

    private func row(for song: Song) -> some View {
        HStack(spacing: 12) {
            artwork(for: song)
            VStack(alignment: .leading, spacing: 2) {
                Text(song.title)
                    .font(.body)
                    .lineLimit(1)
                Text(song.artistName)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer()
            Image(systemName: nowPlayingID == song.id && isPlaying ? "pause.circle.fill" : "play.circle.fill")
                .font(.title2)
                .foregroundStyle(.tint)
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private func artwork(for song: Song) -> some View {
        if let art = song.artwork {
            ArtworkImage(art, width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        } else {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.tertiarySystemBackground))
                .frame(width: 44, height: 44)
                .overlay(Image(systemName: "music.note").foregroundStyle(.secondary))
        }
    }

    // MARK: Authorization states

    private func authorizationPromptView(action: @escaping () -> Void) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "music.note.list")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Apple Music access")
                .font(.title2)
            Text("Stream needs permission to search Apple Music and play songs.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button("Continue", action: action)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var authorizationDeniedView: some View {
        VStack(spacing: 16) {
            Image(systemName: "music.note.list")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Apple Music access denied")
                .font(.title2)
            Text("Open Settings → Claude's Audio Universe → Apple Music to grant access.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Actions

    private func requestAuthorization() {
        Task {
            let status = await MusicAuthorization.request()
            authStatus = status
        }
    }

    private func observeSubscription() async {
        for await subscription in MusicSubscription.subscriptionUpdates {
            hasSubscription = subscription.canPlayCatalogContent
        }
    }

    private func runSearch() async {
        let term = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !term.isEmpty else { results = [] ; return }
        do {
            var request = MusicCatalogSearchRequest(term: term, types: [Song.self])
            request.limit = 25
            let response = try await request.response()
            results = Array(response.songs)
            statusMessage = response.songs.isEmpty ? "No matches." : nil
        } catch {
            statusMessage = "Search failed: \(error.localizedDescription)"
        }
    }

    private func tapped(_ song: Song) async {
        if nowPlayingID == song.id {
            await togglePlayPause()
        } else {
            await play(song)
        }
    }

    private func togglePlayPause() async {
        if hasSubscription {
            if isPlaying {
                player.pause()
                isPlaying = false
            } else {
                do { try await player.play() ; isPlaying = true } catch { statusMessage = error.localizedDescription }
            }
        } else if let avPlayer {
            if isPlaying {
                avPlayer.pause()
                isPlaying = false
            } else {
                avPlayer.play()
                isPlaying = true
            }
        }
    }

    private func play(_ song: Song) async {
        nowPlayingID = song.id
        isPlaying = false

        if hasSubscription {
            avPlayer?.pause()
            avPlayer = nil
            player.queue = [song]
            do {
                try await player.play()
                isPlaying = true
                statusMessage = nil
            } catch {
                statusMessage = "Playback failed: \(error.localizedDescription)"
            }
        } else {
            player.stop()
            guard let preview = song.previewAssets?.first?.url else {
                statusMessage = "No preview available for this song."
                return
            }
            let item = AVPlayerItem(url: preview)
            avPlayer = AVPlayer(playerItem: item)
            avPlayer?.play()
            isPlaying = true
            statusMessage = "Playing 30-second preview (Apple Music subscription not active)."
        }
    }
}
