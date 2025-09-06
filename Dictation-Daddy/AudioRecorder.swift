import Foundation
import AVFoundation

protocol AudioRecorderProtocol {
    func startRecording()
    func stopRecording()
}

class AudioRecorder: ObservableObject, AudioRecorderProtocol {
    @Published var isRecording = false
    var fileURL: URL?
    private var audioEngine = AVAudioEngine()
    private var audioFile: AVAudioFile?

    func startRecording() {
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.fileURL = documentsPath.appendingPathComponent("recording.wav")

        guard let fileURL = self.fileURL else { return }

        do {
            audioFile = try AVAudioFile(forWriting: fileURL, settings: recordingFormat.settings)
        } catch {
            print("Error setting up audio file: \(error.localizedDescription)")
            return
        }

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, when) in
            do {
                try self?.audioFile?.write(from: buffer)
            } catch {
                print("Error writing to audio file: \(error.localizedDescription)")
            }
        }

        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioFile = nil // Close the file
        isRecording = false
    }
}
