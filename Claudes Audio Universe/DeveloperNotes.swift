//
//  DeveloperNotes.swift
//  Claudes Audio Universe
//
//  Created by Michael Fluharty on 4/23/26.
//
//  Canonical reference for how this app is built and why.
//  Mirror this file's content to the project wiki's Developer-Notes.md page
//  after every change.
//

import Foundation

enum DeveloperNotes {
    static let mission = """
    Claude's Audio Universe is a four-tab audio utility: Apple Music playback, \
    voice recording, song identification, and live speech-to-text. Each tab is \
    a single-session tool — nothing is stored, nothing syncs, nothing has \
    history. Users send output to other apps (Notes, Files, Messages, Mail) \
    via the system share sheet when they want to keep something.
    """

    static let architecture = """
    SwiftUI + four Apple audio frameworks. No SwiftData, no CloudKit, no \
    custom networking. Each tab owns exactly one kit.

    • Claudes_Audio_UniverseApp.swift — App entry; one WindowGroup hosting ContentView.
    • ContentView.swift — TabView root with four feature tabs plus Under the Hood.
    • StreamView.swift — MusicKit. Search, play, and share an Apple Music track.
    • RecordView.swift — AVFoundation. Record a clip to temp storage, play it back, share the file.
    • IdentifyView.swift — ShazamKit. Listen for a song, report the match, share song info.
    • TranscribeView.swift — Speech. Live microphone transcription; share the text.
    • AboutView.swift — Standard about page: icon, version, credit, feedback button.
    • UnderTheHoodView.swift — Lists every source file in-app for curious readers.
    • FeedbackView.swift — Mail composer for Bug Report / Feature Request.
    • DeveloperNotes.swift — This file. Mirrors to wiki Developer-Notes.md.
    """

    static let tabs = """
    Four feature tabs plus Under the Hood. Each feature tab is self-contained \
    and session-only — closing the tab or quitting the app discards the \
    in-progress state.

    1. Stream — pick an Apple Music song, hear it play. Playback only, no output.
    2. Record — capture a short clip to temp storage, play it back, share the file.
    3. Identify — tap listen, ShazamKit matches the song. The match auto-adds to the user's "My Shazam Tracks" library (iOS 17+ / macOS 14+), and tapping the match opens it in Apple Music / iTunes Store.
    4. Transcribe — tap start, talk, stop, share the resulting text.
    5. Under the Hood — browse every source file of this app inside the app.
    """

    static let kits = """
    • MusicKit — ApplicationMusicPlayer, MusicCatalogSearchRequest, MusicSubscription
    • AVFoundation — AVAudioRecorder, AVAudioPlayer, AVAudioSession(.playAndRecord)
    • ShazamKit — SHManagedSession (iOS 15+ / macOS 12+); SHLibrary.default.addItems() (iOS 17+ / macOS 14+) for auto-save to "My Shazam Tracks"
    • Speech — SFSpeechRecognizer, SFSpeechAudioBufferRecognitionRequest
    """

    static let entitlementsAndInfoPlist = """
    Info.plist keys:
    • NSMicrophoneUsageDescription — required by Record, Identify, Transcribe
    • NSSpeechRecognitionUsageDescription — required by Transcribe
    • NSAppleMusicUsageDescription — required by Stream (MusicKit)

    Entitlements: app sandbox + network client. No CloudKit, no push, no iCloud.
    """

    static let shareSheetOutput = """
    The app never stores user-generated content. Each output tab handles its \
    output differently:

    • Stream — no output. Pure playback. User is listening, not producing.
    • Record — share sheet with the temp .m4a file.
    • Identify — no share sheet. Two automatic behaviors on a match: \
      (1) the song is added to the user's "My Shazam Tracks" library via \
      SHLibrary.default.addItems() on iOS 17+ / macOS 14+; (2) tapping the \
      matched row opens the song in Apple Music / iTunes Store via the \
      SHMediaItem's appleMusicURL. iOS 15-16 and macOS 12-13 users still \
      get the tap-to-store flow, just not the auto-save.
    • Transcribe — share sheet with the transcribed text as a plain string.

    Share sheet targets are all system-standard (AirDrop, Messages, Mail, \
    Notes, Save to Files, Voice Memos for audio, etc.). The user chooses \
    where the output lives.
    """

    static let versionHistory = """
    v1.0 — Initial release, 2026-04-23.
    """
}
