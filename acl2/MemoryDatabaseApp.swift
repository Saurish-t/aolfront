import SwiftUI

@main
struct MemoryDatabaseApp: App {
    @StateObject private var memoryStore = MemoryStore()
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                if authManager.isOnboarding {
                    OnboardingView()
                        .environmentObject(memoryStore)
                        .environmentObject(authManager)
                } else {
                    ContentView()
                        .environmentObject(memoryStore)
                        .environmentObject(authManager)
                }
            } else {
                WelcomeView()
                    .environmentObject(authManager)
            }
        }
    }
}
