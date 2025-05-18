import SwiftUI
import Foundation

struct HomeView: View {
    @EnvironmentObject var memoryStore: MemoryStore
    @EnvironmentObject var authManager: AuthenticationManager

    @State private var showingAddMemory = false
    @State private var randomMemory: Memory?
    @State private var showingRandomMemory = false
    @State private var navigateToSearch = false
    private let modernPurple = Color(red: 103/255, green: 58/255, blue: 183/255)
    private let whiteBackground = Color.white
    private let purpleAccentOpacity = 0.15

    var body: some View {
        NavigationView {
            ZStack {
                whiteBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {
                        NavigationLink(destination: SearchView(), isActive: $navigateToSearch) {
                            EmptyView()
                        }

                        headerView
                            .padding(.horizontal)
                            .padding(.top, 15)

                        quickActions
                            .padding(.horizontal)

                        featuredMemorySection
                            .padding(.top, 10)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddMemory) {
                AddMemoryView()
            }
            .sheet(isPresented: $showingRandomMemory) {
                if let memory = randomMemory {
                    NavigationView {
                        MemoryDetailView(memory: memory)
                            .navigationBarItems(trailing: Button("Close") {
                                showingRandomMemory = false
                            })
                    }
                }
            }
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Memory Database")
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                    .foregroundColor(modernPurple)

                Spacer()

                Button(action: authManager.signOut) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 20))
                        .foregroundColor(modernPurple)
                }
            }

            if let user = authManager.currentUser {
                Text("Welcome, \(user.name)")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
            } else {
                Text("Your personal memory collection")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }


    private var quickActions: some View {
        HStack(spacing: 20) {
            QuickActionButton(
                title: "Add Memory",
                icon: "plus.circle.fill",
                color: modernPurple
            ) {
                showingAddMemory = true
            }

            QuickActionButton(
                title: "Random Memory",
                icon: "shuffle.circle.fill",
                color: modernPurple.opacity(0.8)
            ) {
                fetchRandomMemory()
            }

            QuickActionButton(
                title: "Search",
                icon: "magnifyingglass.circle.fill",
                color: modernPurple.opacity(0.6)
            ) {
                navigateToSearch = true
            }
        }
    }


    private var featuredMemorySection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Featured Memory of the Hour")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(modernPurple)
                .padding(.horizontal)

            if let uiImage = UIImage(named: "temp") {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .frame(maxWidth: UIScreen.main.bounds.width - 32)
                    .cornerRadius(16)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    .clipped()
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 60))
                    .foregroundColor(modernPurple.opacity(0.5))
                    .frame(height: 200)
                    .frame(maxWidth: UIScreen.main.bounds.width - 32)
                    .cornerRadius(16)
                    .padding(.horizontal)
            }
        }
    }


    func fetchRandomMemory() {
        guard let url = URL(string: "http://192.168.68.98:5004/memory/random") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching random memory: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let fetchedMemory = try decoder.decode(Memory.self, from: data)
                DispatchQueue.main.async {
                    self.randomMemory = fetchedMemory
                    self.showingRandomMemory = true
                }
            } catch {
                if let rawResponse = String(data: data, encoding: .utf8) {
                    print("Raw response: \(rawResponse)")
                }
                print("Error decoding random memory: \(error)")
            }
        }.resume()
    }
}


struct QuickActionButton: View {
    private let modernPurple = Color(red: 103/255, green: 58/255, blue: 183/255)
    private let whiteBackground = Color.white
    var title: String
    var icon: String
    var color: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 60, height: 60)

                    Image(systemName: icon)
                        .font(.system(size: 30))
                        .foregroundColor(color)
                }

                Text(title)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(modernPurple)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Color.white.opacity(0.95))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}


#Preview {
    HomeView()
        .environmentObject(MemoryStore())
        .environmentObject({
            let mock = AuthenticationManager()
            mock.currentUser = User(id: UUID(), name: "Preview User", email: "preview@example.com")
            return mock
        }())
}

