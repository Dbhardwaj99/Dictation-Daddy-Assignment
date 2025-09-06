
import SwiftUI
import AVFoundation

struct RecorderView: View {
    @StateObject private var audioRecorder = AudioRecorder()
    
    @EnvironmentObject var navigationState: NavigationState
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var transcribedText = "Listening..."
    @State private var isTranscribing = false
    @State private var showAlert = false
    
    private let networkManager = NetworkManager()
    var openedFromContentView: Bool = false

    var body: some View {
        ZStack(alignment: .top) {
            (audioRecorder.isRecording ? Color.blue.opacity(0.5) : Color.gray)
                .ignoresSafeArea()

            VStack {
                HStack {
                    if !openedFromContentView {
                        if transcribedText != "Listening..." {
                            withAnimation(.easeInOut(duration: 0.3), {
                                Text("⬆️ Tap here to go back")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .padding(.top, -40)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            })
                        }
                    }
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "house.fill")
                            .foregroundStyle(.white)
                            .font(.title)
                            .padding()
                    }
                }
                
                Spacer(minLength: 200)

                
                if isTranscribing {
                    Text("Transcribing...")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    if transcribedText != "Listening..." && transcribedText != "Transcription failed." {
                        VStack {
                            Text(transcribedText)
                                .font(.title)
                                .fontWeight(.black)
                                .padding(30)
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                UIPasteboard.general.string = transcribedText
                                showAlert = true
                            }) {
                                Image(systemName: "doc.on.doc")
                                    .font(.title)
                            }
                            .padding(.bottom)
                        }
                        .background(Color.brown.opacity(0.4))
                        .cornerRadius(20)
                        .padding()
                    } else {
                        Text(transcribedText)
                            .font(.title)
                            .fontWeight(.black)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                    }
                }

                Spacer(minLength: 100)

                Button(action: {
                    if audioRecorder.isRecording {
                        audioRecorder.stopRecording()
                        if let fileURL = audioRecorder.fileURL {
                            isTranscribing = true
                            networkManager.transcribeAudio(fileURL: fileURL) { text in
                                if let text = text {
                                    self.transcribedText = text
                                } else {
                                    self.transcribedText = "Transcription failed."
                                }
                                isTranscribing = false
                            }
                        }
                    } else {
                        audioRecorder.startRecording()
                        transcribedText = "Listening..."
                    }
                }) {
                    Text(audioRecorder.isRecording ? "Stop Recording" : "Start Recording")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            audioRecorder.startRecording()
        }
        .onDisappear{
            audioRecorder.stopRecording()
            navigationState.navigateToRecorderViaKB = false
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive || newPhase == .background {
                if transcribedText != "Listening..." && transcribedText != "Transcription failed." {
                    if let defaults = UserDefaults(suiteName: "group.com.macbookpro.Dictation-Daddy") {
                        defaults.set(transcribedText, forKey: "transcribedText")
                        defaults.set(Date().timeIntervalSince1970, forKey: "timeOfTranscription")
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Copied!"), message: Text("The text has been copied to your clipboard."), dismissButton: .default(Text("OK")))
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RecorderView()
}
