import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var searchResults: [SearchResult] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    private let modernPurple = Color(red: 103/255, green: 58/255, blue: 183/255)
    private let whiteBackground = Color.white

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    ZStack(alignment: .leading) {
                        if searchText.isEmpty {
                            Text("Search memories...")
                                .foregroundColor(.black)
                                .padding(.leading, 16)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                        }
                        TextField("", text: $searchText)
                            .padding(12)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(modernPurple, lineWidth: 1.5)
                            )
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .onSubmit {
                                performSearch()
                            }
                            .foregroundColor(.black)  // Ensure input text is black
                    }

                    Button(action: performSearch) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(modernPurple)
                            .cornerRadius(10)
                    }
                }
                .padding()

                // Results & States
                if isLoading {
                    Spacer()
                    ProgressView("Searching...")
                        .progressViewStyle(CircularProgressViewStyle(tint: modernPurple))
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(modernPurple)
                    Spacer()
                } else if let error = errorMessage {
                    Spacer()
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                    Spacer()
                } else if searchResults.isEmpty {
                    Spacer()
                    Text("No results found.")
                        .foregroundColor(.gray)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(searchResults) { result in
                                SearchResultCard(result: result)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .background(whiteBackground)
            .navigationTitle(Text("Search Memories")
                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                                .foregroundColor(modernPurple)
            )
        }
    }

    // MARK: - Perform Search
    func performSearch() {
        guard !searchText.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        searchResults = []

        let urlString = "http://192.168.68.98:5004/search"

        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received."
                }
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode([SearchResult].self, from: data)
                DispatchQueue.main.async {
                    self.searchResults = decodedResponse
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Decoding failed: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

// MARK: - Preview

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .preferredColorScheme(.light)
    }
}

