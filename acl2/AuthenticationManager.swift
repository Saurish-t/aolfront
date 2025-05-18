import SwiftUI
import Combine

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isOnboarding = false
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // For demo purposes, any non-empty email/password combination works
            if !email.isEmpty && !password.isEmpty {
                self.currentUser = User(name: "Family Member", email: email)
                self.isAuthenticated = true
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func signUp(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // For demo purposes, any non-empty values work
            if !name.isEmpty && !email.isEmpty && !password.isEmpty {
                self.currentUser = User(name: name, email: email)
                self.isAuthenticated = true
                self.isOnboarding = true
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
    }
    
    func completeOnboarding() {
        isOnboarding = false
    }
}

struct User {
    var id = UUID()
    var name: String
    var email: String
}
