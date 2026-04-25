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
import AVFoundation

struct RecordView: View {
    @State private var permission: AVAudioApplication.recordPermission = AVAudioApplication.shared.recordPermission
    @State private var phase: Phase = .idle
    @State private var recordingURL: URL?
    @State private var recordingStartedAt: Date?
    @State private var recordingDuration: TimeInterval = 0
    @State private var statusMessage: String?
    @State private var recorder: AVAudioRecorder?
    @State private var player: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var playbackDelegate = PlaybackDelegate()

    enum Phase { case idle, recording, finished }

    var body: some View {
        AppShell {
            content
                .navigationTitle("Record")
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
        VStack(spacing: 32) {
            Spacer()
            timeDisplay
            phaseControls
                .padding(.horizontal, 32)
            if let statusMessage {
                Text(statusMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            Spacer()
        }
        .onAppear { playbackDelegate.onFinish = { isPlaying = false } }
    }

    private var timeDisplay: some View {
        TimelineView(.periodic(from: .now, by: 0.1)) { context in
            Text(formatElapsed(currentElapsed(at: context.date)))
                .font(.system(size: 56, weight: .light, design: .monospaced))
                .foregroundStyle(phase == .recording ? .red : .primary)
        }
    }

    private func currentElapsed(at date: Date) -> TimeInterval {
        if phase == .recording, let started = recordingStartedAt {
            return date.timeIntervalSince(started)
        }
        return recordingDuration
    }

    @ViewBuilder
    private var phaseControls: some View {
        switch phase {
        case .idle:
            Button(action: startRecording) {
                Label("Record", systemImage: "record.circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.red)
        case .recording:
            Button(action: stopRecording) {
                Label("Stop", systemImage: "stop.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        case .finished:
            VStack(spacing: 12) {
                Button(action: togglePlayback) {
                    Label(isPlaying ? "Pause" : "Play",
                          systemImage: isPlaying ? "pause.fill" : "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                if let recordingURL {
                    ShareLink(item: recordingURL) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }

                Button(action: resetForNew) {
                    Label("Record New", systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
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
            Text("Record needs permission to capture audio from the microphone.")
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

    private func startRecording() {
        statusMessage = nil
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("recording-\(UUID().uuidString).m4a")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)

            let r = try AVAudioRecorder(url: url, settings: settings)
            r.prepareToRecord()
            r.record()
            recorder = r
            recordingURL = url
            recordingStartedAt = Date()
            recordingDuration = 0
            phase = .recording
        } catch {
            statusMessage = "Recording failed to start: \(error.localizedDescription)"
        }
    }

    private func stopRecording() {
        guard let r = recorder else { return }
        recordingDuration = r.currentTime
        r.stop()
        recorder = nil
        phase = .finished
        prepareLoadedPlayer()
    }

    private func prepareLoadedPlayer() {
        guard let recordingURL else { return }
        do {
            let p = try AVAudioPlayer(contentsOf: recordingURL)
            p.delegate = playbackDelegate
            p.prepareToPlay()
            player = p
        } catch {
            statusMessage = "Could not load recording for playback: \(error.localizedDescription)"
        }
    }

    private func togglePlayback() {
        guard let p = player else { return }
        if isPlaying {
            p.pause()
            isPlaying = false
        } else {
            p.play()
            isPlaying = true
        }
    }

    private func resetForNew() {
        player?.stop()
        player = nil
        isPlaying = false
        if let recordingURL {
            try? FileManager.default.removeItem(at: recordingURL)
        }
        recordingURL = nil
        recordingStartedAt = nil
        recordingDuration = 0
        statusMessage = nil
        phase = .idle
    }

    private func formatElapsed(_ seconds: TimeInterval) -> String {
        let total = Int(seconds)
        let minutes = total / 60
        let secs = total % 60
        return String(format: "%02d:%02d", minutes, secs)
    }

    @MainActor
    final class PlaybackDelegate: NSObject, AVAudioPlayerDelegate {
        var onFinish: () -> Void = {}
        nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            Task { @MainActor in onFinish() }
        }
    }
}
