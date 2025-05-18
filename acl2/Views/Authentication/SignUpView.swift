import SwiftUI

struct NewSignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authManager: AuthenticationManager
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    let purple = Color(red: 103/255, green: 58/255, blue: 183/255)

    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [purple.opacity(0.8), purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 100, height: 100)
                                Image(systemName: "person.badge.plus")
                                    .font(.system(size: 50, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            Text("Create Account")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundColor(purple)
                            Text("Start preserving your memories")
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .foregroundColor(purple.opacity(0.7))
                        }.padding(.top, 30)

                        Group {
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(purple)
                                    .padding(.leading)
                                TextField("", text: $name, prompt: Text("Enter your name").foregroundColor(.black))
                                    .disableAutocorrection(true)
                                    .font(.system(size: 16, design: .rounded))
                                    .foregroundColor(.black)
                            }
                            .inputStyle()

                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(purple)
                                    .padding(.leading)
                                TextField("", text: $email, prompt: Text("Enter your email").foregroundColor(.black))
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .font(.system(size: 16, design: .rounded))
                                    .foregroundColor(.black)
                            }
                            .inputStyle()

                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(purple)
                                    .padding(.leading)
                                ZStack(alignment: .leading) {
                                    if password.isEmpty {
                                        Text("Create a password")
                                            .foregroundColor(.black.opacity(0.6))
                                            .font(.system(size: 16, design: .rounded))
                                            .padding(.leading, 8)
                                    }
                                    SecureField("", text: $password)
                                        .font(.system(size: 16, design: .rounded))
                                        .foregroundColor(.black)
                                        .padding(8)
                                }
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(16)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.purple.opacity(0.3), lineWidth: 1))
                                .shadow(color: Color.purple.opacity(0.1), radius: 5, x: 0, y: 2)
                            }
                            .inputStyle()

                            HStack {
                                Image(systemName: "lock.shield.fill")
                                    .foregroundColor(purple)
                                    .padding(.leading)
                                ZStack(alignment: .leading) {
                                    if confirmPassword.isEmpty {
                                        Text("Confirm your password")
                                            .foregroundColor(.black.opacity(0.6))
                                            .font(.system(size: 16, design: .rounded))
                                            .padding(.leading, 8)
                                    }
                                    SecureField("", text: $confirmPassword)
                                        .font(.system(size: 16, design: .rounded))
                                        .foregroundColor(.black)
                                        .padding(8)
                                }
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(16)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.purple.opacity(0.3), lineWidth: 1))
                                .shadow(color: Color.purple.opacity(0.1), radius: 5, x: 0, y: 2)
                            }
                            .inputStyle()
                        }
                        .padding(.horizontal)

                        if showError {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .padding(.horizontal)
                        }

                        HStack {
                            Image(systemName: "checkmark.square.fill")
                                .foregroundColor(purple)
                            Text("I agree to the ")
                                .font(.system(size: 15, design: .rounded))
                                .foregroundColor(purple.opacity(0.7)) +
                            Text("Terms & Conditions")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(purple)
                        }
                        .padding(.horizontal)

                        Button {
                            signUp()
                        } label: {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Create Account")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(purple)
                        .cornerRadius(16)
                        .shadow(color: purple.opacity(0.5), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)
                        .disabled(isLoading)

                        HStack {
                            VStack { Divider() }
                            Text("OR")
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(purple.opacity(0.6))
                                .padding(.horizontal, 8)
                            VStack { Divider() }
                        }
                        .padding(.horizontal)

                        HStack(spacing: 15) {
                            socialButton(icon: "apple.logo", color: .black)
                            socialButton(icon: "g.circle.fill", color: Color(red: 219/255, green: 68/255, blue: 55/255))
                            socialButton(icon: "f.circle.fill", color: Color(red: 66/255, green: 103/255, blue: 178/255))
                        }
                        .padding(.horizontal)

                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(purple.opacity(0.7))
                                .font(.system(size: 16, design: .rounded))
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("Log In")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(purple)
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

    private func signUp() {
        isLoading = true
        showError = false

        if name.isEmpty || email.isEmpty || password.isEmpty {
            errorMessage = "Please fill in all fields."
            showError = true
            isLoading = false
            return
        }
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            showError = true
            isLoading = false
            return
        }

        authManager.signUp(name: name, email: email, password: password) { success in
            isLoading = false
            if success {
                presentationMode.wrappedValue.dismiss()
            } else {
                errorMessage = "Failed to create account. Please try again."
                showError = true
            }
        }
    }

    @ViewBuilder
    func socialButton(icon: String, color: Color) -> some View {
        Button {
            // Social signup action
        } label: {
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

extension View {
    func inputStyle() -> some View {
        self
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.purple.opacity(0.3), lineWidth: 1))
            .shadow(color: Color.purple.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct NewSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NewSignUpView()
            .environmentObject(AuthenticationManager())
    }
}

