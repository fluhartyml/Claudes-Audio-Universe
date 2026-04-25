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
#if canImport(UIKit)
import UIKit
#endif

struct FeedbackView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var feedbackType = "Bug Report"
    @State private var feedbackText = ""
    @State private var showMailError = false

    private let feedbackTypes = ["Bug Report", "Feature Request", "General Feedback"]
    private let recipient = "michael.fluharty@mac.com"

    var deviceInfo: String {
        #if os(iOS)
        let device = UIDevice.current
        return """
        App: Claude's Audio Universe \(appVersion)
        Device: \(device.model)
        System: \(device.systemName) \(device.systemVersion)
        """
        #else
        return "App: Claude's Audio Universe \(appVersion) (macOS)"
        #endif
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Feedback Type") {
                    Picker("Type", selection: $feedbackType) {
                        ForEach(feedbackTypes, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Details") {
                    TextEditor(text: $feedbackText)
                        .frame(minHeight: 150)
                }

                Section("Device Info (auto-included)") {
                    Text(deviceInfo)
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Send Feedback")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Send") { sendFeedback() }
                        .disabled(feedbackText.isEmpty)
                }
            }
            .alert("Cannot Send Email", isPresented: $showMailError) {
                Button("OK") {}
            } message: {
                Text("This device is not configured to send email. Please email \(recipient) directly.")
            }
        }
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    private func sendFeedback() {
        let subject = "Claude's Audio Universe - \(feedbackType)"
        let body = """
        \(feedbackText)

        ---
        \(deviceInfo)
        """

        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let mailto = "mailto:\(recipient)?subject=\(encodedSubject)&body=\(encodedBody)"

        #if os(iOS)
        if let url = URL(string: mailto), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            dismiss()
        } else {
            showMailError = true
        }
        #endif
    }
}
