# Dictation-Daddy

Dictation-Daddy is an iOS/macOS application designed to provide a seamless dictation experience, allowing users to quickly transcribe spoken words into text. It features a main application for managing dictations and a custom keyboard extension for direct text insertion into any app.

## Features

*   **Audio Recording:** Capture high-quality audio directly within the main application.
*   **Speech-to-Text Transcription:** Utilizes the powerful Groq API (Whisper large v3 turbo model) for accurate and fast transcription of audio recordings.
*   **Custom Keyboard Extension:** A dedicated keyboard extension allows users to initiate dictation and insert transcribed text directly into any text field across iOS/macOS.
*   **Deep Linking Integration:** Seamlessly switch between the keyboard extension and the main application for an integrated workflow.
*   **Shared Data:** Transcribed text is shared between the main app and the keyboard extension for immediate insertion.

## Technologies Used

*   **SwiftUI:** For building the user interface across both the main application and the keyboard extension.
*   **AVFoundation:** Apple's framework for handling audio recording.
*   **KeyboardKit:** A powerful library simplifying the development of custom keyboard extensions.
*   **Groq API:** Provides the advanced speech-to-text transcription capabilities.

## Setup and Installation

To get Dictation-Daddy up and running on your local machine, follow these steps:

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/your-username/Dictation-Daddy.git
    cd Dictation-Daddy
    ```
    *(Note: Replace `https://github.com/your-username/Dictation-Daddy.git` with the actual repository URL if it's hosted.)*

2.  **Open in Xcode:**
    Open the `Dictation-Daddy.xcodeproj` file in Xcode.

3.  **Configure Groq API Key:**
    The application requires a Groq API key for transcription. You need to add this key to your project's `Info.plist` file.
    *   Open `Dictation-Daddy/Info.plist`.
    *   Add a new row with the key `GroqAPIKey` (String type) and set its value to your actual Groq API key.

4.  **Configure App Group:**
    For the main application and the keyboard extension to share data (like transcribed text), you must configure an App Group.
    *   In Xcode, select the `Dictation-Daddy` target.
    *   Go to the "Signing & Capabilities" tab.
    *   Click `+ Capability` and add "App Groups".
    *   Add a new App Group identifier, for example, `group.com.yourcompany.Dictation-Daddy`.
    *   Repeat this process for the `Dictation-Daddy-Keyboard` target, ensuring you use the *exact same* App Group identifier.

5.  **Build and Run:**
    *   Select the `Dictation-Daddy` target and run the application on a simulator or a physical device.

6.  **Enable Custom Keyboard (iOS/macOS Settings):**
    After installing the app, you need to enable the custom keyboard:
    *   **On iOS:** Go to `Settings > General > Keyboard > Keyboards > Add New Keyboard...` and select "Dictation-Daddy". Make sure to enable "Allow Full Access".
    *   **On macOS:** Go to `System Settings > Keyboard > Input Sources`, click the `+` button, search for "Dictation-Daddy", and add it.

## How to Use

### Using the Main Application

1.  Launch the "Dictation-Daddy" app.
2.  Tap on "Go to Recorder" to access the recording interface.
3.  Start recording your audio. Once done, the app will transcribe the audio using the Groq API.

### Using the Keyboard Extension

1.  In any application, bring up the keyboard.
2.  Switch to the "Dictation-Daddy" keyboard (usually by tapping the globe icon).
3.  Tap the microphone icon on the keyboard's top bar.
4.  This will launch the main "Dictation-Daddy" app directly into the recording view.
5.  Record your dictation in the main app.
6.  Once transcribed, switch back to the app where you were typing.
7.  The transcribed text will automatically be inserted into your text field by the keyboard extension.
