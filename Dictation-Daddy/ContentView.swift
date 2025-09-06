import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigationState: NavigationState

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: RecorderView(openedFromContentView: true)) {
                    Text("Go to Recorder")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // Hidden NavigationLink for programmatic navigation
                NavigationLink(destination: RecorderView(openedFromContentView: false), isActive: $navigationState.navigateToRecorderViaKB) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
