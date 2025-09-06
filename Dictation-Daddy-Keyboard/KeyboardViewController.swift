//
//  KeyboardViewController.swift
//  Dictation-Daddy-Keyboard
//
//  Created by MacBook Pro on 05/09/25.
//

import UIKit
import SwiftUI
import KeyboardKit

struct TopViewWithButton: View {
    @State private var isTapped = false
    var onTap : (Bool) -> (Void)
    @Environment(\.openURL) var openURL
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                if let url = URL(string: "dictation-daddy://recorder") {
                    openURL(url)
                }
            },label: {
                Image(systemName: "record.circle")
                    .resizable()
                    .foregroundStyle(.red)
                    .frame(width: 30, height: 30)
            })
            .onAppear(perform: {
                onTap(true)
            })
            .padding(.trailing, 10)
        }
    }
}

extension KeyboardApp {
    
    static var keyboardKitDemo: KeyboardApp {
        .init(
            name: "KeyboardKit",
            locales: .keyboardKitSupported,
        )
    }
}

class KeyboardViewController: KeyboardInputViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(for: .keyboardKitDemo) { result in }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillSetupKeyboardView() {
        setupKeyboardView { [weak self] controller in
            KeyboardView(
                state: controller.state,
                services: controller.services,
                buttonContent: { $0.view },
                buttonView: { $0.view },
                collapsedView: { $0.view },
                emojiKeyboard: { $0.view },
                toolbar: { _ in
                    TopViewWithButton(onTap: {_ in
                        self?.refreshKeyboardUI()
                    })
                }
            )
        }
    }
    
    func refreshKeyboardUI() {
        if let defaults = UserDefaults(suiteName: "group.com.macbookpro.Dictation-Daddy") {
            if let transcriptionTime = defaults.object(forKey: "timeOfTranscription") as? TimeInterval,
               let transcribedText = defaults.string(forKey: "transcribedText") {
                
                let timeSinceTranscription = Date().timeIntervalSince1970 - transcriptionTime
                
                if timeSinceTranscription < 20 {
                    textDocumentProxy.insertText(transcribedText)
                }
                
                defaults.removeObject(forKey: "timeOfTranscription")
                defaults.removeObject(forKey: "transcribedText")
            }
        }
    }
}
