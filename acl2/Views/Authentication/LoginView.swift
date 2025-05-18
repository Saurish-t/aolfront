import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.colorScheme) var colorScheme
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(colorScheme == .dark ? UIColor.systemBackground : UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Header
                        VStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.primaryGradient)
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Welcome Back")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.textPrimary(colorScheme))
                            
                            Text("Log in to access your memories")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.textSecondary(colorScheme))
                        }
                        .padding(.top, 30)
                        
                        // Form
                        VStack(spacing: 20) {
                            // Email field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.textSecondary(colorScheme))
                                
                                HStack {
                                    Image(systemName: "envelope.fill")
                                        .foregroundColor(AppTheme.primary)
                                        .padding(.leading)
                                    
                                    TextField("Enter your email", text: $email)
                                        .padding()
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                }
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(AppTheme.primary.opacity(0.3), lineWidth: 1)
                                )
                            }
                            
                            // Password field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.textSecondary(colorScheme))
                                
                                HStack {
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(AppTheme.primary)
                                        .padding(.leading)
                                    
                                    SecureField("Enter your password", text: $password)
                                        .padding()
                                }
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(AppTheme.primary.opacity(0.3), lineWidth: 1)
                                )
                            }
                            
                            // Forgot password
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    // Forgot password action
                                }) {
                                    Text("Forgot Password?")
                                        .font(.subheadline)
                                        .foregroundColor(AppTheme.primary)
                                }
                            }
                            .padding(.top, -5)
                        }
                        .padding(.horizontal)
                        
                        // Error message
                        if showError {
                            Text(errorMessage)
                                .font(.subheadline)
                                .foregroundColor(AppTheme.accent)
                                .padding(.horizontal)
                        }
                        
                        // Login button
                        Button(action: {
                            login()
                        }) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Log In")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .padding(.horizontal)
                        .disabled(isLoading)
                        
                        // Divider
                        HStack {
                            VStack { Divider() }
                            Text("OR")
                                .font(.caption)
                                .foregroundColor(AppTheme.textSecondary(colorScheme))
                                .padding(.horizontal, 8)
                            VStack { Divider() }
                        }
                        .padding(.horizontal)
                        
                        // Social login buttons
                        HStack(spacing: 15) {
                            SocialLoginButton(icon: "apple.logo", color: .black)
                            SocialLoginButton(icon: "g.circle.fill", color: Color(hex: "DB4437"))
                            SocialLoginButton(icon: "f.circle.fill", color: Color(hex: "4267B2"))
                        }
                        .padding(.horizontal)
                        
                        // Sign up prompt
                        HStack {
                            Text("Don't have an account?")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.textSecondary(colorScheme))
                            
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                                // Need to add a way to show sign up view
                            }) {
                                Text("Sign Up")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(AppTheme.primary)
                            }
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func login() {
        isLoading = true
        showError = false
        
        authManager.signIn(email: email, password: password) { success in
            isLoading = false
            
            if success {
                presentationMode.wrappedValue.dismiss()
            } else {
                errorMessage = "Invalid email or password. Please try again."
                showError = true
            }
        }
    }
}

struct SocialLoginButton: View {
    var icon: String
    var color: Color
    
    var body: some View {
        Button(action: {
            // Social login action
        }) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(color)
                .cornerRadius(16)
                .shadow(color: color.opacity(0.3), radius: 5, x: 0, y: 3)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthenticationManager())
    }
}
