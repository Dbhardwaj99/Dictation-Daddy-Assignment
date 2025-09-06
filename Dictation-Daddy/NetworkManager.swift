import Foundation

class NetworkManager {
    private let apiKey: String
    private let transcriptionURL = URL(string: "https://api.groq.com/openai/v1/audio/transcriptions")!

    init() {
        if let apiKey = Bundle.main.infoDictionary?["GroqAPIKey"] as? String {
            self.apiKey = apiKey
        } else {
            fatalError("API key not found in Info.plist. Please add it.")
        }
    }

    func transcribeAudio(fileURL: URL, completion: @escaping (String?) -> Void) {
        var request = URLRequest(url: transcriptionURL)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        var data = Data()

        // Add the audio file data
        do {
            let audioData = try Data(contentsOf: fileURL)
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: audio/wav\r\n\r\n".data(using: .utf8)!)
            data.append(audioData)
            data.append("\r\n".data(using: .utf8)!)
        } catch {
            print("Error reading audio file: \(error)")
            completion(nil)
            return
        }

        // Add the model parameter
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        data.append("whisper-large-v3-turbo".data(using: .utf8)!)
        data.append("\r\n".data(using: .utf8)!)

        data.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = data

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API Error: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received from API")
                completion(nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let text = json["text"] as? String {
                    DispatchQueue.main.async {
                        completion(text)
                    }
                } else {
                    print("Error parsing JSON response")
                    completion(nil)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }

        task.resume()
    }
}