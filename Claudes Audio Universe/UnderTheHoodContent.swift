//
//  UnderTheHoodContent.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/25/26.
//
//  ── Under the Hood ──────────────────────────────────────────────
//  Hand-authored mirror of every Swift file's UTH callout block.
//  When you change a callout in a source file, also update the
//  matching entry here. Phase 2 (deferred) replaces this file with
//  build-time extraction from the live source. The "Open on GitHub"
//  tap on each row keeps readers tied to the latest published source
//  even when this constant drifts.
//  ────────────────────────────────────────────────────────────────
//

import Foundation

enum UnderTheHoodContent {
    static let repoSourceBase = "https://github.com/fluhartyml/Claudes-Audio-Universe/blob/main/Claudes%20Audio%20Universe/"

    static let entries: [FileEntry] = [
        FileEntry(
            filename: "Claudes_Audio_UniverseApp.swift",
            purpose: "App entry — quiet by design.",
            callout: """
                The Xcode template's SwiftData scaffolding is stripped here because Audio Universe stores nothing — every tab is session-only and outputs leave through the share sheet. Each feature tab also owns its own audio session config, so the entry point stays quiet and the work happens per-tab.
                """
        ),
        FileEntry(
            filename: "ContentView.swift",
            purpose: "TabView root.",
            callout: """
                Five sibling tabs because the feature tools are peers, with Under the Hood beside them as a first-class destination rather than hidden behind a settings gear. No programmatic tab-selection state — each tab owns its own session; the shell knows nothing about what's running inside.
                """
        ),
        FileEntry(
            filename: "AppShell.swift",
            purpose: "Shared (i)-button toolbar wrapper.",
            callout: """
                Wrapping container that gives every feature view its own NavigationStack with a top-trailing (i) info button. The button presents AboutView as a sheet. Each tab sets its own navigation title on its inner content; AppShell owns only the shared (i) plumbing so the tab body stays feature-focused.
                """
        ),
        FileEntry(
            filename: "PlaceholderTab.swift",
            purpose: "Temporary scaffold body (to be deleted).",
            callout: """
                A single parameterized scaffold so each feature view can be filled in independently without touching the shell. As real implementations land in StreamView, RecordView, IdentifyView, and TranscribeView, this file's call sites shrink; once all feature views ship real bodies, this file is deleted.
                """
        ),
        FileEntry(
            filename: "StreamView.swift",
            purpose: "Stream tab — MusicKit.",
            callout: """
                ApplicationMusicPlayer rather than SystemMusicPlayer — the latter would hijack the user's actual Music.app queue, which is hostile in a single-session tool. MusicSubscription is checked before any catalog playback so non-subscribers see why nothing happens. Search is term-based against the catalog; this view never touches the user's library.
                """
        ),
        FileEntry(
            filename: "RecordView.swift",
            purpose: "Record tab — AVFoundation.",
            callout: """
                AVAudioRecorder over AVAudioEngine because the goal is capture-to-file, not real-time DSP. The session category is .playAndRecord so the same view can play back what it just captured without paying a category-switch cost. Output is .m4a (AAC) — small, portable, accepted everywhere the share sheet sends it.
                """
        ),
        FileEntry(
            filename: "IdentifyView.swift",
            purpose: "Identify tab — ShazamKit.",
            callout: """
                SHManagedSession (iOS 15+ / macOS 12+) over raw SHSession because it owns the audio-buffer plumbing — fewer code paths to maintain. SHLibrary.default.addItems() auto-saves to "My Shazam Tracks" on iOS 17+ / macOS 14+; older OSes still get the tap-through to Apple Music via SHMediaItem.appleMusicURL.
                """
        ),
        FileEntry(
            filename: "TranscribeView.swift",
            purpose: "Transcribe tab — Speech.",
            callout: """
                SFSpeechAudioBufferRecognitionRequest streams the live mic rather than re-transcribing a file. On-device recognition is preferred when supported (no audio leaves the device); cloud fallback runs only when the recognizer doesn't support local for the active locale. The recognizer respects user locale unless explicitly overridden.
                """
        ),
        FileEntry(
            filename: "AboutView.swift",
            purpose: "About sheet.",
            callout: """
                Standard about page — icon, name, version, credit, then four outbound affordances: Send Feedback (mailto via FeedbackView), Support / Wiki (GitHub), Privacy Policy (fluharty.me), and Portfolio (fluharty.me). App icon image is read from the bundle's primary CFBundleIcons entry rather than referenced by static name, so a future icon swap doesn't break this view.
                """
        ),
        FileEntry(
            filename: "FeedbackView.swift",
            purpose: "Feedback form — mailto.",
            callout: """
                Mailto-based feedback form — type segmented picker, free text body, and an auto-included device info block (model, OS, app version). Avoids MFMailComposeViewController so it works even when the system Mail account isn't set up; falls back to a plain alert when the user has no mailto handler.
                """
        ),
        FileEntry(
            filename: "UnderTheHoodView.swift",
            purpose: "Under the Hood tab — this view.",
            callout: """
                This view IS the Under the Hood feature — a list of the app's own source files plus each file's UTH callout block (the comment header you're reading right now), surfaced in-app. Phase 1 ships file list and callout extraction; Phase 2 adds inline Lexicon popups so any Swift keyword in the rendered source can be tapped for a definition.
                """
        ),
        FileEntry(
            filename: "UnderTheHoodContent.swift",
            purpose: "Hand-authored callout mirror.",
            callout: """
                Hand-authored mirror of every Swift file's UTH callout block. When you change a callout in a source file, also update the matching entry here. Phase 2 (deferred) replaces this file with build-time extraction from the live source. The "Open on GitHub" tap on each row keeps readers tied to the latest published source even when this constant drifts.
                """
        ),
        FileEntry(
            filename: "DeveloperNotes.swift",
            purpose: "Architecture spec — single source of truth.",
            callout: """
                Canonical reference for how this app is built and why. The wiki Developer-Notes page mirrors this file's content. Where this file and the wiki disagree, this file wins; when they disagree, sync the wiki to match.
                """
        )
    ]

    struct FileEntry: Identifiable {
        let id = UUID()
        let filename: String
        let purpose: String
        let callout: String

        var githubURL: URL? {
            let encoded = filename.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? filename
            return URL(string: repoSourceBase + encoded)
        }
    }
}
