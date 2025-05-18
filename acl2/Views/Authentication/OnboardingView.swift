import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var currentPage = 0
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to Memory Database",
            description: "Your personal memory collection for preserving life's moments and sharing them with family.",
            imageName: "brain.head.profile",
            backgroundColor: AppTheme.primary
        ),
        OnboardingPage(
            title: "Capture Your Memories",
            description: "Add photos, audio recordings, and detailed descriptions to preserve your memories exactly as you remember them.",
            imageName: "camera.fill",
            backgroundColor: AppTheme.secondary
        ),
        OnboardingPage(
            title: "Organize Your Timeline",
            description: "View your memories chronologically and filter them by year, people, or location.",
            imageName: "calendar",
            backgroundColor: Color(hex: "00B894")
        ),
        OnboardingPage(
            title: "Connect with Family",
            description: "Share your memories with family members and receive their messages and memory nudges.",
            imageName: "person.3.fill",
            backgroundColor: Color(hex: "FDCB6E")
        ),
        OnboardingPage(
            title: "AI-Powered Insights",
            description: "Discover connections between memories and get personalized insights about your life's journey.",
            imageName: "sparkles",
            backgroundColor: AppTheme.accent
        )
    ]
    
    var body: some View {
        ZStack {
            // Background color
            LinearGradient(
                gradient: Gradient(colors: [pages[currentPage].backgroundColor, pages[currentPage].backgroundColor.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                // Skip button
                HStack {
                    Spacer()
                    
                    Button(action: {
                        authManager.completeOnboarding()
                    }) {
                        Text("Skip")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            )
                    }
                    .padding()
                }
                
                Spacer()
                
                // Content
                VStack(spacing: 30) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 160, height: 160)
                        
                        Image(systemName: pages[currentPage].imageName)
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                    }
                    
                    Text(pages[currentPage].title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(pages[currentPage].description)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal)
                .offset(y: -20)
                
                Spacer()
                
                // Page indicators
                HStack(spacing: 10) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.white : Color.white.opacity(0.4))
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(.bottom, 20)
                
                // Navigation buttons
                HStack {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            )
                        }
                    } else {
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            if currentPage < pages.count - 1 {
                                currentPage += 1
                            } else {
                                authManager.completeOnboarding()
                            }
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .transition(.slide)
        .animation(.easeInOut, value: currentPage)
    }
}

struct OnboardingPage {
    var title: String
    var description: String
    var imageName: String
    var backgroundColor: Color
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(AuthenticationManager())
    }
}
