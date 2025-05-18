import SwiftUI

struct WelcomeView: View {
    @State private var showLogin = false
    @State private var showSignUp = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Background gradient
            AppTheme.welcomeGradient
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 30) {
                Spacer()
                
                // App logo
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                    }
                    
                    Text("Memory Database")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Preserve your memories for generations")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // Feature highlights
                VStack(spacing: 15) {
                    FeatureRow(icon: "photo.on.rectangle", title: "Store memories with photos and audio")
                    FeatureRow(icon: "person.2.circle", title: "Share with family members")
                    FeatureRow(icon: "brain", title: "AI-powered memory connections")
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 15) {
                    Button(action: {
                        showLogin = true
                    }) {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(AppTheme.primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    }
                    
                    Button(action: {
                        showSignUp = true
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .padding(.bottom, 30)
        }
        .sheet(isPresented: $showLogin) {
            LoginView()
        }
        .sheet(isPresented: $showSignUp) {
            NewSignUpView()
        }
    }
}

struct FeatureRow: View {
    var icon: String
    var title: String
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.body)
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
