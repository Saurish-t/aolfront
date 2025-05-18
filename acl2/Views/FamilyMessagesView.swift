import SwiftUI

struct FamilyMessagesView: View {
    @State private var messages: [FamilyMessage] = sampleMessages
    
    var body: some View {
        NavigationView {
            List {
                ForEach(messages) { message in
                    FamilyMessageRow(message: message)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Family Messages")
        }
    }
}

struct FamilyMessage: Identifiable {
    var id = UUID()
    var senderName: String
    var content: String
    var timestamp: Date
    var isRead: Bool
    var memoryReference: Memory?
}

struct FamilyMessageRow: View {
    var message: FamilyMessage
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(message.senderName)
                            .font(.headline)
                        
                        Spacer()
                        
                        Text(timeAgo(from: message.timestamp))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(message.content)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(isExpanded ? nil : 2)
                }
            }
            
            if !isExpanded {
                Button(action: {
                    isExpanded.toggle()
                }) {
                    Text("Read more")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            if isExpanded {
                if let memory = message.memoryReference {
                    NavigationLink(destination: MemoryDetailView(memory: memory)) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                                .foregroundColor(.blue)
                            
                            Text("View related memory: \(memory.title)")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                
                HStack {
                    Button(action: {
                        // Reply functionality
                    }) {
                        Label("Reply", systemImage: "arrowshape.turn.up.left.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isExpanded.toggle()
                    }) {
                        Text("Show less")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 5)
            }
        }
        .padding(.vertical, 5)
    }
    
    func timeAgo(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return day == 1 ? "Yesterday" : "\(day) days ago"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) hour\(hour == 1 ? "" : "s") ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) minute\(minute == 1 ? "" : "s") ago"
        } else {
            return "Just now"
        }
    }
}

// Sample data
let sampleMessages: [FamilyMessage] = [
    FamilyMessage(
        senderName: "Mom",
        content: "I was looking through our old photo albums and found this picture from your first day of school. Do you remember how excited you were? You couldn't wait to show everyone your new backpack!",
        timestamp: Date().addingTimeInterval(-3600 * 2),
        isRead: false,
        memoryReference: MemoryStore().memories.first
    ),
    FamilyMessage(
        senderName: "Dad",
        content: "Hey kiddo, remember our fishing trip to the lake last summer? I was thinking we should plan another one soon. Those were some good times!",
        timestamp: Date().addingTimeInterval(-3600 * 24),
        isRead: true
    ),
    FamilyMessage(
        senderName: "Sister",
        content: "Found this old video of us dancing in the living room when we were kids. Still can't believe mom kept all these memories! Want me to send it to you?",
        timestamp: Date().addingTimeInterval(-3600 * 48),
        isRead: true
    ),
    FamilyMessage(
        senderName: "Uncle Bob",
        content: "Your aunt and I were reminiscing about that family reunion at the lake house. Remember when we all went swimming and you caught that huge fish? Good times!",
        timestamp: Date().addingTimeInterval(-3600 * 72),
        isRead: true,
        memoryReference: MemoryStore().memories[0]
    ),
    FamilyMessage(
        senderName: "Grandma",
        content: "I was baking your favorite cookies today and it reminded me of when you used to help me in the kitchen. You were always so eager to lick the spoon! I've attached the recipe in case you want to make them yourself.",
        timestamp: Date().addingTimeInterval(-3600 * 96),
        isRead: true
    )
]

struct FamilyMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        FamilyMessagesView()
    }
}
