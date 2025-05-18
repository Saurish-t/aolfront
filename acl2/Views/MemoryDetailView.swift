import SwiftUI
import MapKit

struct MemoryDetailView: View {
    var memory: Memory
    @State private var showingMap = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(memory.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(memory.timestamp, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Photos
                if !memory.media.images_data.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(memory.media.images_data, id: \.filename) { imageData in
                                if let image = decodeBase64Image(imageData.data_base64) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 250, height: 250)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    // Placeholder for memories without photos
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                        
                        VStack {
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            
                            Text("No photos")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.headline)
                    
                    Text(memory.description)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)
                
                // Location
                if let location = memory.location {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Location")
                            .font(.headline)
                        
                        if let coordinate = location.coordinate {
                            Button(action: {
                                showingMap = true
                            }) {
                                HStack {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(.red)
                                    
                                    Text(location.name)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                            }
                        } else {
                            Text(location.name)
                                .foregroundColor(.primary)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Tags
                /*
                if !memory.tags.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Tags")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(memory.tags, id: \.self) { tag in
                                    Text(tag)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.blue.opacity(0.1))
                                        .foregroundColor(.blue)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                */
                
                // People
                /*
                if !memory.people.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("People")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(memory.people, id: \.name) { person in
                                    VStack {
                                        Image(systemName: "person.circle.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.blue)
                                        
                                        Text(person.name)
                                            .font(.caption)
                                        
                                        if !person.relation.isEmpty {
                                            Text("(\(person.relation))")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                */
            }
            .padding(.vertical)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingMap) {
            if let location = memory.location, let coordinate = location.coordinate {
                LocationMapView(coordinate: coordinate, locationName: location.name)
            }
        }
    }
    
    func decodeBase64Image(_ base64String: String) -> UIImage? {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: data)
    }
}

struct LocationMapView: View {
    var coordinate: CLLocationCoordinate2D
    var locationName: String
    @State private var region: MKCoordinateRegion
    
    init(coordinate: CLLocationCoordinate2D, locationName: String) {
        self.coordinate = coordinate
        self.locationName = locationName
        _region = State(initialValue: MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $region, annotationItems: [MapAnnotation(coordinate: coordinate)]) { item in
                MapMarker(coordinate: item.coordinate, tint: .red)
            }
            .navigationTitle(locationName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    struct MapAnnotation: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
}

struct MemoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MemoryDetailView(memory: MemoryStore().memories[0])
        }
    }
}
