import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var memoryStore: MemoryStore
    @State private var selectedYear: Int?
    @State private var timelineData: [TimelineMemory] = []
    @State private var selectedMemory: Memory?
    @State private var isShowingMemoryDetail = false
    
    struct TimelineMemory: Identifiable, Codable {
        var id: String
        var title: String
        var timestamp: String
        var thumbnail_base64: String?
    }
    
    let modernPurple = Color(red: 103/255, green: 58/255, blue: 183/255)
    
    var years: [Int] {
        let calendar = Calendar.current
        let yearsSet = Set(timelineData.compactMap { memory in
            if let date = ISO8601DateFormatter().date(from: memory.timestamp) {
                return calendar.component(.year, from: date)
            }
            return nil
        })
        return Array(yearsSet).sorted(by: >)
    }
    
    var filteredMemories: [TimelineMemory] {
        if let selectedYear = selectedYear {
            let calendar = Calendar.current
            return timelineData.filter {
                if let date = ISO8601DateFormatter().date(from: $0.timestamp) {
                    return calendar.component(.year, from: date) == selectedYear
                }
                return false
            }
        } else {
            return timelineData
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                Text("Timeline")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        YearButton(title: "All", isSelected: selectedYear == nil) {
                            withAnimation {
                                selectedYear = nil
                            }
                        }
                        
                        ForEach(years, id: \.self) { year in
                            YearButton(title: "\(year)", isSelected: selectedYear == year) {
                                withAnimation {
                                    selectedYear = year
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    )
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                
                Divider()
                    .padding(.horizontal)
                
                if filteredMemories.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 60))
                            .foregroundColor(modernPurple.opacity(0.7))
                        
                        Text("No memories found")
                            .font(.title3.weight(.medium))
                            .foregroundColor(modernPurple.opacity(0.6))
                        
                        if selectedYear != nil {
                            Button(action: {
                                withAnimation {
                                    selectedYear = nil
                                }
                            }) {
                                Text("Show all years")
                                    .fontWeight(.semibold)
                                    .foregroundColor(modernPurple)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredMemories) { memory in
                                MemoryCard(memory: memory) {
                                    fetchMemoryDetails(memoryID: memory.id)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    .background(Color.white)
                }
            }
            .onAppear {
                fetchTimeline()
            }
            .sheet(isPresented: $isShowingMemoryDetail) {
                if let memory = selectedMemory {
                    MemoryDetailView(memory: memory)
                }
            }
            .background(Color.white)
        }
        .font(.system(.body, design: .rounded))
    }
    
    @ViewBuilder
    func YearButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? modernPurple : modernPurple.opacity(0.15))
                )
                .foregroundColor(isSelected ? .white : modernPurple)
                .shadow(color: isSelected ? modernPurple.opacity(0.4) : .clear, radius: 6, x: 0, y: 3)
                .animation(.easeInOut(duration: 0.3), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    func MemoryCard(memory: TimelineMemory, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 15) {
                if let thumbnailBase64 = memory.thumbnail_base64,
                   let imageData = Data(base64Encoded: thumbnailBase64),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .cornerRadius(12)
                        .clipped()
                        .shadow(color: Color.black.opacity(0.12), radius: 4, x: 0, y: 2)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 70, height: 70)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 28))
                                .foregroundColor(.gray.opacity(0.6))
                        )
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(memory.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    if let date = ISO8601DateFormatter().date(from: memory.timestamp) {
                        Text(date, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 16, weight: .semibold))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func fetchTimeline() {
        guard let url = URL(string: "http://192.168.68.98:5004/timeline") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching timeline: \(error)")
                return
            }
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let memories = try decoder.decode([TimelineMemory].self, from: data)
                DispatchQueue.main.async {
                    withAnimation {
                        self.timelineData = memories
                    }
                }
            } catch {
                print("Error decoding timeline data: \(error)")
            }
        }.resume()
    }
    
    func fetchMemoryDetails(memoryID: String) {
        guard let numericPart = memoryID.split(separator: "_").last,
              let numericID = Int(numericPart) else {
            print("Invalid memory ID format")
            return
        }
        
        let numericIDString = String(numericID)
        guard let url = URL(string: "http://192.168.68.98:5004/memory/\(numericIDString)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching memory details: \(error)")
                return
            }
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let memory = try decoder.decode(Memory.self, from: data)
                DispatchQueue.main.async {
                    self.selectedMemory = memory
                    self.isShowingMemoryDetail = true
                }
            } catch {
                print("Error decoding memory details: \(error)")
            }
        }.resume()
    }
}

#Preview {
    TimelineView()
        .environmentObject(MemoryStore())
}

