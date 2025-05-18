import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @Environment(\.colorScheme) var colorScheme

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white 
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().unselectedItemTintColor = UIColor.systemGray3
    }

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)

                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(1)

                TimelineView()
                    .tabItem {
                        Label("Timeline", systemImage: "calendar")
                    }
                    .tag(2)

                ARMemoryView()
                    .tabItem {
                        Label("AR", systemImage: "arkit")
                    }
                    .tag(3)
            }
            .accentColor(AppTheme.primary)
            .font(.system(size: 13, weight: .medium, design: .rounded))
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MemoryStore())
        .environmentObject(AuthenticationManager())
}

