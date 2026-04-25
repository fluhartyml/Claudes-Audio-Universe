//
//  UnderTheHoodContent.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  Hand-authored mirror of every Swift file's UTH callout block AND
//  the file's full source text. When you change a file, also update
//  the matching entry here. Phase 2 (deferred) replaces this file
//  with build-time extraction from the live source. The "Open on
//  GitHub" tap on each row keeps readers tied to the latest
//  published source even when this constant drifts.
//  ────────────────────────────────────────────────────────────────
//

import Foundation

enum UnderTheHoodContent {
    static let repoSourceBase = "https://github.com/fluhartyml/Claudes-Audio-Universe/blob/main/Claudes%20Audio%20Universe/"

    static let entries: [FileEntry] = [
        FileEntry(
            filename: "Claudes_Audio_UniverseApp.swift",
            purpose: "App entry — this page left intentionally blank.",
            callout: """
                The Xcode template's SwiftData scaffolding is stripped here because Audio Universe stores nothing — every tab is session-only and outputs leave through the share sheet. Each feature tab also owns its own audio session config, so the entry point stays quiet and the work happens per-tab.
                """,
            source: Sources.appEntry
        ),
        FileEntry(
            filename: "ContentView.swift",
            purpose: "TabView root.",
            callout: """
                Five sibling tabs because the feature tools are peers, with Under the Hood beside them as a first-class destination rather than hidden behind a settings gear. No programmatic tab-selection state — each tab owns its own session; the shell knows nothing about what's running inside.
                """,
            source: Sources.contentView
        ),
        FileEntry(
            filename: "AppShell.swift",
            purpose: "Shared (i)-button toolbar wrapper.",
            callout: """
                Wrapping container that gives every feature view its own NavigationStack with a top-trailing (i) info button. The button presents AboutView as a sheet. Each tab sets its own navigation title on its inner content; AppShell owns only the shared (i) plumbing so the tab body stays feature-focused.
                """,
            source: Sources.appShell
        ),
        FileEntry(
            filename: "PlaceholderTab.swift",
            purpose: "Temporary scaffold body (to be deleted).",
            callout: """
                A single parameterized scaffold so each feature view can be filled in independently without touching the shell. As real implementations land in StreamView, RecordView, IdentifyView, and TranscribeView, this file's call sites shrink; once all feature views ship real bodies, this file is deleted.
                """,
            source: Sources.placeholderTab
        ),
        FileEntry(
            filename: "StreamView.swift",
            purpose: "Stream tab — MusicKit.",
            callout: """
                ApplicationMusicPlayer rather than SystemMusicPlayer — the latter would hijack the user's actual Music.app queue, which is hostile in a single-session tool. MusicSubscription is checked before any catalog playback so non-subscribers see why nothing happens. Search is term-based against the catalog; this view never touches the user's library.
                """,
            source: Sources.streamView
        ),
        FileEntry(
            filename: "RecordView.swift",
            purpose: "Record tab — AVFoundation.",
            callout: """
                AVAudioRecorder over AVAudioEngine because the goal is capture-to-file, not real-time DSP. The session category is .playAndRecord so the same view can play back what it just captured without paying a category-switch cost. Output is .m4a (AAC) — small, portable, accepted everywhere the share sheet sends it.
                """,
            source: Sources.recordView
        ),
        FileEntry(
            filename: "IdentifyView.swift",
            purpose: "Identify tab — ShazamKit.",
            callout: """
                SHManagedSession (iOS 15+ / macOS 12+) over raw SHSession because it owns the audio-buffer plumbing — fewer code paths to maintain. SHLibrary.default.addItems() auto-saves to "My Shazam Tracks" on iOS 17+ / macOS 14+; older OSes still get the tap-through to Apple Music via SHMediaItem.appleMusicURL.
                """,
            source: Sources.identifyView
        ),
        FileEntry(
            filename: "TranscribeView.swift",
            purpose: "Transcribe tab — Speech.",
            callout: """
                SFSpeechAudioBufferRecognitionRequest streams the live mic rather than re-transcribing a file. On-device recognition is preferred when supported (no audio leaves the device); cloud fallback runs only when the recognizer doesn't support local for the active locale. The recognizer respects user locale unless explicitly overridden.
                """,
            source: Sources.transcribeView
        ),
        FileEntry(
            filename: "AboutView.swift",
            purpose: "About sheet.",
            callout: """
                Standard about page — icon, name, version, credit, then four outbound affordances: Send Feedback (mailto via FeedbackView), Support / Wiki (GitHub), Privacy Policy (fluharty.me), and Portfolio (fluharty.me). App icon image is read from the bundle's primary CFBundleIcons entry rather than referenced by static name, so a future icon swap doesn't break this view.
                """,
            source: Sources.aboutView
        ),
        FileEntry(
            filename: "FeedbackView.swift",
            purpose: "Feedback form — mailto.",
            callout: """
                Mailto-based feedback form — type segmented picker, free text body, and an auto-included device info block (model, OS, app version). Avoids MFMailComposeViewController so it works even when the system Mail account isn't set up; falls back to a plain alert when the user has no mailto handler.
                """,
            source: Sources.feedbackView
        ),
        FileEntry(
            filename: "UnderTheHoodView.swift",
            purpose: "Under the Hood tab — this view.",
            callout: """
                This view IS the Under the Hood feature — a list of the app's own source files plus each file's UTH callout block (the comment header you're reading right now), surfaced in-app. Phase 1 ships file list and callout extraction; Phase 2 adds inline Lexicon popups so any Swift keyword in the rendered source can be tapped for a definition.
                """,
            source: Sources.underTheHoodView
        ),
        FileEntry(
            filename: "UnderTheHoodContent.swift",
            purpose: "Hand-authored callout & source mirror.",
            callout: """
                Hand-authored mirror of every Swift file's UTH callout block AND the file's full source text. When you change a file, also update the matching entry here. Phase 2 (deferred) replaces this file with build-time extraction from the live source. The "Open on GitHub" tap on each row keeps readers tied to the latest published source even when this constant drifts.
                """,
            source: Sources.underTheHoodContentMirror
        ),
        FileEntry(
            filename: "DeveloperNotes.swift",
            purpose: "Architecture spec — single source of truth.",
            callout: """
                Canonical reference for how this app is built and why. The wiki Developer-Notes page mirrors this file's content. Where this file and the wiki disagree, this file wins; sync the wiki to match.
                """,
            source: Sources.developerNotes
        )
    ]

    struct FileEntry: Identifiable {
        let id = UUID()
        let filename: String
        let purpose: String
        let callout: String
        let source: String

        var githubURL: URL? {
            let encoded = filename.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? filename
            return URL(string: repoSourceBase + encoded)
        }
    }
}

// MARK: - Source mirrors
//
// Each constant below holds the literal source of a file in this app.
// Raw multi-line strings (#"""..."""#) avoid interpolating \( ... )
// sequences that appear inside the actual code.

private enum Sources {

    static let appEntry = #"""
//
//  Claudes_Audio_UniverseApp.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/23/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  The Xcode template's SwiftData scaffolding is stripped here
//  because Audio Universe stores nothing — every tab is session-only
//  and outputs leave through the share sheet. Each feature tab also
//  owns its own audio session config, so the entry point stays quiet
//  and the work happens per-tab.
//
//  Bible Page (deeper): Part I → App Entry Point.
//  ────────────────────────────────────────────────────────────────
//

import SwiftUI

@main
struct Claudes_Audio_UniverseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
"""#

    static let contentView = #"""
//
//  ContentView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/23/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  Five sibling tabs because the feature tools are peers, with
//  Under the Hood beside them as a first-class destination rather
//  than hidden behind a settings gear. No programmatic tab-selection
//  state — each tab owns its own session; the shell knows nothing
//  about what's running inside.
//
//  Bible Page (deeper): Reference → ContentView.swift.
//  ────────────────────────────────────────────────────────────────
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            StreamView()
                .tabItem {
                    Label("Stream", systemImage: "play.circle")
                }

            RecordView()
                .tabItem {
                    Label("Record", systemImage: "mic.circle")
                }

            IdentifyView()
                .tabItem {
                    Label("Identify", systemImage: "shazam.logo")
                }

            TranscribeView()
                .tabItem {
                    Label("Transcribe", systemImage: "text.bubble")
                }

            UnderTheHoodView()
                .tabItem {
                    Label("Under the Hood", systemImage: "wrench.and.screwdriver")
                }
        }
    }
}

#Preview {
    ContentView()
}
"""#

    static let appShell = #"""
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
"""#

    static let placeholderTab = #"""
//
//  PlaceholderTab.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  A single parameterized scaffold so each feature view can be
//  filled in independently without touching the shell. As real
//  implementations land in StreamView, RecordView, IdentifyView,
//  and TranscribeView, this file's call sites shrink; once all
//  feature views ship real bodies, this file is deleted.
//  ────────────────────────────────────────────────────────────────
//

import SwiftUI

struct PlaceholderTab: View {
    let icon: String
    let title: String
    let summary: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.title)
            Text(summary)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)
        }
    }
}
"""#

    static let streamView = #"""
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

    // …additional view + action methods elided in this in-app mirror;
    // tap "Open on GitHub" above to read the full source.
}
"""#

    static let recordView = #"""
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
    @State private var recorder: AVAudioRecorder?
    @State private var player: AVAudioPlayer?
    @State private var isPlaying = false

    enum Phase { case idle, recording, finished }

    private func startRecording() {
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
            phase = .recording
        } catch {
            // surface error in real implementation
        }
    }

    // …UI body, playback, share, and reset methods elided in this in-app
    // mirror; tap "Open on GitHub" above to read the full source.
}
"""#

    static let identifyView = #"""
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
    @State private var phase: Phase = .idle
    @State private var matches: [SHMediaItem] = []
    @State private var session: SHManagedSession?

    enum Phase { case idle, listening }

    private func startListening() {
        let s = SHManagedSession()
        session = s
        phase = .listening

        Task {
            let result = await s.result()
            await handle(result)
        }
    }

    @MainActor
    private func handle(_ result: SHSession.Result) async {
        phase = .idle
        session = nil

        switch result {
        case .match(let match):
            guard let item = match.mediaItems.first else { return }
            if !matches.contains(where: { $0.shazamID == item.shazamID }) {
                matches.insert(item, at: 0)
            }
            try? await SHLibrary.default.addItems([item])
        case .noMatch:
            break
        case .error(_, _):
            break
        }
    }

    private func open(_ item: SHMediaItem) {
        guard let url = item.appleMusicURL else { return }
        UIApplication.shared.open(url)
    }

    // …UI body, permission states, and row/list views elided in this
    // in-app mirror; tap "Open on GitHub" above to read the full source.
}
"""#

    static let transcribeView = #"""
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
    @State private var transcript: String = ""
    @State private var recognizer = SFSpeechRecognizer()
    @State private var request: SFSpeechAudioBufferRecognitionRequest?
    @State private var task: SFSpeechRecognitionTask?
    @State private var engine = AVAudioEngine()

    private func startListening() {
        guard let recognizer, recognizer.isAvailable else { return }

        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .defaultToSpeaker])
        try? session.setActive(true, options: .notifyOthersOnDeactivation)

        let req = SFSpeechAudioBufferRecognitionRequest()
        req.shouldReportPartialResults = true
        if recognizer.supportsOnDeviceRecognition {
            req.requiresOnDeviceRecognition = true
        }
        request = req

        let inputNode = engine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            req.append(buffer)
        }

        engine.prepare()
        try? engine.start()

        task = recognizer.recognitionTask(with: req) { result, _ in
            if let result {
                Task { @MainActor in
                    transcript = result.bestTranscription.formattedString
                }
            }
        }
    }

    // …UI body, permission states, teardown elided in this in-app
    // mirror; tap "Open on GitHub" above to read the full source.
}
"""#

    static let aboutView = #"""
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

    private let supportURL = URL(string: "https://github.com/fluhartyml/Claudes-Audio-Universe/wiki")!
    private let privacyURL = URL(string: "https://fluharty.me/audiouniverse-privacy")!
    private let portfolioURL = URL(string: "https://fluharty.me")!

    private var appIcon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
              let lastIcon = iconFiles.last else {
            return nil
        }
        return UIImage(named: lastIcon)
    }

    // …UI body and outbound link buttons elided in this in-app mirror;
    // tap "Open on GitHub" above to read the full source.
}
"""#

    static let feedbackView = #"""
//
//  FeedbackView.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  Mailto-based feedback form — type segmented picker, free text
//  body, and an auto-included device info block (model, OS,
//  app version). Avoids MFMailComposeViewController so it works
//  even when the system Mail account isn't set up; falls back
//  to a plain alert when the user has no mailto handler.
//  ────────────────────────────────────────────────────────────────
//

import SwiftUI

struct FeedbackView: View {
    @State private var feedbackType = "Bug Report"
    @State private var feedbackText = ""

    private let recipient = "michael.fluharty@mac.com"

    private func sendFeedback(deviceInfo: String) {
        let subject = "Claude's Audio Universe - bug report"
        let body = "\(feedbackText)\n\n---\n\(deviceInfo)"

        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let mailto = "mailto:\(recipient)?subject=\(encodedSubject)&body=\(encodedBody)"

        if let url = URL(string: mailto), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    // …UI body, type picker, text editor, and device-info block elided
    // in this in-app mirror; tap "Open on GitHub" above to read the
    // full source.
}
"""#

    static let underTheHoodView = #"""
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
    @State private var selected: UnderTheHoodContent.FileEntry?

    var body: some View {
        AppShell {
            List {
                Section("Source Files") {
                    ForEach(UnderTheHoodContent.entries) { entry in
                        Button { selected = entry } label: {
                            // row content
                        }
                    }
                }
            }
            .sheet(item: $selected) { entry in
                FileDetailSheet(entry: entry)
            }
        }
    }
}

// FileDetailSheet renders filename, callout, source code mirror,
// and an "Open on GitHub" link — see full source for details.
"""#

    static let underTheHoodContentMirror = #"""
//
//  UnderTheHoodContent.swift
//  Claudes Audio Universe
//
//  Hand-authored mirror of every Swift file in this app: filename,
//  one-line purpose, the file's UTH callout block, and a snippet of
//  the file's source (full source available via the Open on GitHub
//  link on each detail sheet).
//
//  Phase 2 (deferred) replaces this hand-authored mirror with a
//  build-time extraction pass that reads the live source files and
//  pipes them into a generated Swift constant. Until then, when you
//  change a file in the app, also update the matching entry here.

import Foundation

enum UnderTheHoodContent {
    static let entries: [FileEntry] = [
        // …one FileEntry per Swift file in the app; see full source.
    ]

    struct FileEntry: Identifiable {
        let id = UUID()
        let filename: String
        let purpose: String
        let callout: String
        let source: String
    }
}
"""#

    static let developerNotes = #"""
//
//  DeveloperNotes.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/23/26.
//
//  Canonical reference for how this app is built and why.
//  Mirror this file's content to the project wiki's Developer-Notes.md
//  page after every change.
//

import Foundation

enum DeveloperNotes {
    static let mission = "..."
    static let architecture = "..."
    static let tabs = "..."
    static let kits = "..."
    static let entitlementsAndInfoPlist = "..."
    static let shareSheetOutput = "..."
    static let versionHistory = "..."
}
"""#
}
