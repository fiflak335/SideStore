import SwiftUI

struct ContentView: View {
    private enum Tab {
        case home
        case device
        case about
    }

    @State private var selection: Tab = .home

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem { Label("Start", systemImage: "iphone") }
                .tag(Tab.home)

            DeviceInfoView()
                .tabItem { Label("Urządzenie", systemImage: "info.circle") }
                .tag(Tab.device)

            AboutView()
                .tabItem { Label("O aplikacji", systemImage: "questionmark.circle") }
                .tag(Tab.about)
        }
        .tint(Color.accentColor)
    }
}

#Preview {
    ContentView()
}
