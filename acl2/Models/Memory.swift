import Foundation
import SwiftUI
import CoreLocation

struct Memory: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var timestamp: Date
    var location: LocationData?
    var media: MediaData
    //var tags: [String]
    //var people: [Person]
    
    struct LocationData: Codable {
        var latitude: Double?
        var longitude: Double?
        var name: String
        
        var coordinate: CLLocationCoordinate2D? {
            if let lat = latitude, let lng = longitude {
                return CLLocationCoordinate2D(latitude: lat, longitude: lng)
            }
            return nil
        }
    }
    
    struct MediaData: Codable {
        var images_data: [ImageData]
        
        struct ImageData: Codable {
            var filename: String
            var data_base64: String
        }
    }
    
    struct Person: Codable {
        var name: String
        var relation: String
    }
}

class MemoryStore: ObservableObject {
    @Published var memories: [Memory] = []
    
    init() {
        loadSampleData()
    }
    
    func loadSampleData() {
        let calendar = Calendar.current
        let now = Date()
        
        // Sample memories
        /*
        memories = [
            Memory(
                id: UUID().uuidString,
                title: "Family Reunion",
                description: "Annual family reunion at the lake house. Everyone was there, including Uncle Bob who told his famous fishing stories.",
                timestamp: calendar.date(byAdding: .day, value: -30, to: now)!,
                location: Memory.LocationData(latitude: 34.052235, longitude: -118.243683, name: "Lake House"),
                media: Memory.MediaData(
                    images_data: []
                ),
                //tags: ["family", "summer", "lake"],
                //people: [Memory.Person(name: "Mom", relation: "Mother"), Memory.Person(name: "Dad", relation: "Father"), Memory.Person(name: "Uncle Bob", relation: "Uncle"), Memory.Person(name: "Aunt Mary", relation: "Aunt")]
            ),
            Memory(
                id: UUID().uuidString,
                title: "First Day of College",
                description: "Moving into the dorm and meeting my roommate for the first time. We went to the campus tour together.",
                timestamp: calendar.date(byAdding: .year, value: -4, to: now)!,
                location: Memory.LocationData(latitude: 40.7128, longitude: -74.0060, name: "University Campus"),
                media: Memory.MediaData(
                    images_data: []
                ),
                //tags: ["college", "beginnings", "education"],
                //people: [Memory.Person(name: "Roommate Sam", relation: "Roommate"), Memory.Person(name: "RA Jessica", relation: "Resident Assistant")]
            ),
            Memory(
                id: UUID().uuidString,
                title: "Birthday Party",
                description: "My surprise 30th birthday party. Everyone managed to keep it a secret!",
                timestamp: calendar.date(byAdding: .month, value: -2, to: now)!,
                media: Memory.MediaData(
                    images_data: []
                ),
                //tags: ["birthday", "celebration", "surprise"],
                //people: [Memory.Person(name: "Sarah", relation: "Friend"), Memory.Person(name: "John", relation: "Friend"), Memory.Person(name: "Mike", relation: "Friend"), Memory.Person(name: "Lisa", relation: "Friend")]
            ),
            Memory(
                id: UUID().uuidString,
                title: "Trip to Paris",
                description: "Visiting the Eiffel Tower for the first time. The view from the top was breathtaking.",
                timestamp: calendar.date(byAdding: .year, value: -1, to: now)!,
                location: Memory.LocationData(latitude: 48.8584, longitude: 2.2945, name: "Paris, France"),
                media: Memory.MediaData(
                    images_data: []
                ),
                //tags: ["travel", "europe", "vacation"],
                //people: [Memory.Person(name: "Travel Buddy Alex", relation: "Friend")]
            ),
            Memory(
                id: UUID().uuidString,
                title: "Graduation Day",
                description: "Finally receiving my diploma after years of hard work. Mom and Dad were so proud.",
                timestamp: calendar.date(byAdding: .year, value: -3, to: now)!,
                media: Memory.MediaData(
                    images_data: []
                ),
                //tags: ["graduation", "achievement", "education"],
                //people: [Memory.Person(name: "Mom", relation: "Mother"), Memory.Person(name: "Dad", relation: "Father"), Memory.Person(name: "Professor Johnson", relation: "Professor")]
            )
        ]
    }
         */
    
    func addMemory(_ memory: Memory) {
        memories.append(memory)
    }
    
    func deleteMemory(at indexSet: IndexSet) {
        memories.remove(atOffsets: indexSet)
    }
    
    func getRandomMemory() -> Memory? {
        guard !memories.isEmpty else { return nil }
        let randomIndex = Int.random(in: 0..<memories.count)
        return memories[randomIndex]
    }
    
    func searchMemories(query: String) -> [Memory] {
        guard !query.isEmpty else { return memories }
        
        return memories.filter { memory in
            memory.title.lowercased().contains(query.lowercased()) ||
            memory.description.lowercased().contains(query.lowercased()) //||
            //memory.tags.contains { $0.lowercased().contains(query.lowercased()) } ||
            //memory.people.contains { $0.name.lowercased().contains(query.lowercased()) }
        }
    }
    
    //func getMemoriesByPerson(name: String) -> [Memory] {
        //return memories.filter { memory in
            //memory.people.contains { $0.name.lowercased().contains(name.lowercased()) }
        //}
    }
}
