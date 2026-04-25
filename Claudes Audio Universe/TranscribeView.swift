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
import Speech
import AVFoundation

struct TranscribeView: View {
    @State private var speechAuth: SFSpeechRecognizerAuthorizationStatus = SFSpeechRecognizer.authorizationStatus()
    @State private var micPermission: AVAudioApplication.recordPermission = AVAudioApplication.shared.recordPermission
    @State private var phase: Phase = .idle
    @State private var transcript: String = ""
    @State private var statusMessage: String?
    @State private var recognizer = SFSpeechRecognizer()
    @State private var request: SFSpeechAudioBufferRecognitionRequest?
    @State private var task: SFSpeechRecognitionTask?
    @State private var engine = AVAudioEngine()

    enum Phase { case idle, listening }

    var body: some View {
        AppShell {
            content
                .navigationTitle("Transcribe")
                .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch (speechAuth, micPermission) {
        case (.notDetermined, _), (_, .undetermined):
            promptView
        case (.denied, _), (.restricted, _), (_, .denied):
            deniedView
        case (.authorized, .granted):
            mainView
        default:
            deniedView
        }
    }

    // MARK: Authorized

    private var mainView: some View {
        VStack(spacing: 16) {
            transcriptArea
            controls
                .padding(.horizontal)
            if let statusMessage {
                Text(statusMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }

    private var transcriptArea: some View {
        ScrollView {
            Text(transcript.isEmpty ? "Tap Start, then talk. Your speech will appear here." : transcript)
                .font(.body)
                .foregroundStyle(transcript.isEmpty ? AnyShapeStyle(.secondary) : AnyShapeStyle(.primary))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    @ViewBuilder
    private var controls: some View {
        switch phase {
        case .idle:
            HStack(spacing: 12) {
                Button(action: startListening) {
                    Label("Start", systemImage: "mic.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                if !transcript.isEmpty {
                    ShareLink(item: transcript) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)

                    Button(action: clear) {
                        Label("Clear", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
            }
        case .listening:
            Button(action: stopListening) {
                Label("Stop", systemImage: "stop.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }

    // MARK: Permission states

    private var promptView: some View {
        VStack(spacing: 16) {
            Image(systemName: "waveform.and.mic")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Speech & microphone access")
                .font(.title2)
            Text("Transcribe needs the microphone to capture your voice and Speech access to convert it to text.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button("Continue", action: requestPermissions)
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
            Text("Access denied")
                .font(.title2)
            Text("Open Settings → Claude's Audio Universe and grant Microphone and Speech Recognition access.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Actions

    private func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                speechAuth = status
            }
        }
        Task {
            let granted = await AVAudioApplication.requestRecordPermission()
            micPermission = granted ? .granted : .denied
        }
    }

    private func startListening() {
        statusMessage = nil
        guard let recognizer, recognizer.isAvailable else {
            statusMessage = "Speech recognizer is not available right now."
            return
        }

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .defaultToSpeaker])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            statusMessage = "Could not configure audio session: \(error.localizedDescription)"
            return
        }

        let req = SFSpeechAudioBufferRecognitionRequest()
        req.shouldReportPartialResults = true
        if recognizer.supportsOnDeviceRecognition {
            req.requiresOnDeviceRecognition = true
        }
        request = req

        let inputNode = engine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            req.append(buffer)
        }

        engine.prepare()
        do {
            try engine.start()
        } catch {
            statusMessage = "Could not start audio engine: \(error.localizedDescription)"
            return
        }

        task = recognizer.recognitionTask(with: req) { result, error in
            if let result {
                Task { @MainActor in
                    transcript = result.bestTranscription.formattedString
                }
            }
            if error != nil || (result?.isFinal ?? false) {
                Task { @MainActor in
                    teardown()
                }
            }
        }

        phase = .listening
    }

    private func stopListening() {
        teardown()
    }

    private func teardown() {
        engine.stop()
        engine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        request = nil
        task?.cancel()
        task = nil
        phase = .idle
    }

    private func clear() {
        transcript = ""
        statusMessage = nil
    }
}
