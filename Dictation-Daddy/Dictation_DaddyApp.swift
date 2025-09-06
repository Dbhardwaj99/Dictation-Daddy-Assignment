import SwiftUI

@main
struct Dictation_DaddyApp: App {
    var navigationState = NavigationState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationState)
                .onOpenURL { url in
                    handleDeepLink(url: url)
                }
        }
    }
    
    func handleDeepLink(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let host = components.host else {
            print("Invalid URL")
            return
        }

        switch host {
        case "recorder":
            navigationState.navigateToRecorderViaKB = true
        default:
            print("Unknown deep link host: \(host)")
        }
    }
}
