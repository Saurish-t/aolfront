import Foundation
import UIKit
import Combine

// Model to handle AR-related data and network requests
class ARProcessor: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var stilURL: URL?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Function to send image to server and receive STIL file
    func processImage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        isLoading = true
        errorMessage = nil
        
        // Convert image to data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            isLoading = false
            errorMessage = "Failed to process image"
            completion(.failure(NSError(domain: "ARProcessor", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
        
        // Create URL request
        guard let url = URL(string: "https://your-api-endpoint.com/process-image") else {
            isLoading = false
            errorMessage = "Invalid API endpoint"
            completion(.failure(NSError(domain: "ARProcessor", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid API URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData
        
        // Create and start data task
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    self?.errorMessage = "Server error"
                    completion(.failure(NSError(domain: "ARProcessor", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])))
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    completion(.failure(NSError(domain: "ARProcessor", code: 4, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                // For demo purposes, we'll save the received data to a temporary file
                // In a real app, you would handle the STIL file appropriately
                let tempDir = FileManager.default.temporaryDirectory
                let fileURL = tempDir.appendingPathComponent("response.stil")
                
                do {
                    try data.write(to: fileURL)
                    self?.stilURL = fileURL
                    completion(.success(fileURL))
                } catch {
                    self?.errorMessage = "Failed to save file: \(error.localizedDescription)"
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
