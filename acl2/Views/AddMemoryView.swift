import SwiftUI
import PhotosUI
import MapKit

extension CLLocationCoordinate2D: Identifiable, Equatable {
    public var id: String {
        "\(latitude),\(longitude)"
    }

    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct AddMemoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var memoryStore: MemoryStore
    @Environment(\.colorScheme) var colorScheme

    @State private var title = ""
    @State private var description = ""
    @State private var date = ISO8601DateFormatter().date(from: "2020-07-01T12:00:00") ?? Date()
    @State private var locationName = ""
    @State private var locationCoordinates: CLLocationCoordinate2D? = nil
    @State private var tags = ""
    @State private var people = ""
    @State private var selectedPhotos: [UIImage] = []
    @State private var isRecordingAudio = false
    @State private var showingImagePicker = false
    @State private var showingLocationPicker = false

    let purple = Color(red: 103/255, green: 58/255, blue: 183/255)

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Memory Details")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(purple)
                ) {
                    TextField("Title", text: $title)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(purple)
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .accentColor(purple)

                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.caption)
                            .foregroundColor(purple.opacity(0.7))
                        TextEditor(text: $description)
                            .frame(minHeight: 100)
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(purple)
                    }
                }

                Section(header: Text("Location")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(purple)
                ) {
                    TextField("Location Name", text: $locationName)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(purple)

                    Button {
                        showingLocationPicker = true
                    } label: {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(purple)
                            Text("Choose on Map")
                                .foregroundColor(purple)
                                .font(.system(size: 16, design: .rounded))
                        }
                    }

                    if let coordinates = locationCoordinates {
                        Text("Lat: \(coordinates.latitude), Lng: \(coordinates.longitude)")
                            .font(.caption)
                            .foregroundColor(purple.opacity(0.7))
                    }
                }

                Section(header: Text("Photos")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(purple)
                ) {
                    if selectedPhotos.isEmpty {
                        Button {
                            showingImagePicker = true
                        } label: {
                            HStack {
                                Image(systemName: "photo.on.rectangle")
                                    .foregroundColor(purple)
                                Text("Add Photos")
                                    .foregroundColor(purple)
                                    .font(.system(size: 16, design: .rounded))
                            }
                        }
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(selectedPhotos.indices, id: \.self) { index in
                                    Image(uiImage: selectedPhotos[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)
                                        .overlay(
                                            Button {
                                                selectedPhotos.remove(at: index)
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.white)
                                                    .background(Color.black.opacity(0.7))
                                                    .clipShape(Circle())
                                            }
                                            .padding(5),
                                            alignment: .topTrailing
                                        )
                                }
                                Button {
                                    showingImagePicker = true
                                } label: {
                                    VStack {
                                        Image(systemName: "plus")
                                            .font(.system(size: 30))
                                            .foregroundColor(purple)
                                        Text("Add More")
                                            .font(.caption)
                                            .foregroundColor(purple)
                                    }
                                    .frame(width: 100, height: 100)
                                    .background(purple.opacity(0.15))
                                    .cornerRadius(8)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
            .navigationTitle("Add Memory")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(purple),
                trailing: Button("Save") {
                    saveMemory()
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(title.isEmpty ? purple.opacity(0.4) : purple)
                .disabled(title.isEmpty)
            )
            .sheet(isPresented: $showingImagePicker) {
                MultiImagePicker(selectedImages: $selectedPhotos)
            }
            .sheet(isPresented: $showingLocationPicker) {
                MapPickerView(selectedCoordinate: $locationCoordinates)
            }
        }
    }

    func saveMemory() {
        let tagsList = tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let peopleList = people.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        let locationData: [String: Any] = [
            "name": locationName,
            "coordinates": [
                "lat": locationCoordinates?.latitude ?? 34.0195,
                "lng": locationCoordinates?.longitude ?? -118.4912
            ]
        ]

        let peopleData = peopleList.map { ["name": $0, "relation": "mother"] }

        let memoryData: [String: Any] = [
            "id": "m_001",
            "title": title,
            "description": description,
            "timestamp": ISO8601DateFormatter().string(from: date),
            "location": locationData,
            //"tags": tagsList,
            //"people": peopleData,
            "media": ["images_data": selectedPhotos.map { image in
                [
                    "filename": UUID().uuidString + ".jpg",
                    "data_base64": image.jpegData(compressionQuality: 0.8)?.base64EncodedString() ?? ""
                ]
            }],
            //"keywords": tagsList
        ]

        guard let url = URL(string: "http://192.168.68.98:5004/memory/upload") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: memoryData)

        URLSession.shared.dataTask(with: request) { _, _, _ in }.resume()
    }
}

struct MapPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedCoordinate: CLLocationCoordinate2D?

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.0195, longitude: -118.4912),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    let purple = Color(red: 103/255, green: 58/255, blue: 183/255)

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: false, annotationItems: selectedCoordinate != nil ? [selectedCoordinate!] : []) { coordinate in
                MapMarker(coordinate: coordinate, tint: purple)
            }
            .onChange(of: region.center) { newCenter in
                selectedCoordinate = newCenter
            }
            .edgesIgnoringSafeArea(.all)

            if let coordinate = selectedCoordinate {
                Text("Selected: \(coordinate.latitude), \(coordinate.longitude)")
                    .padding()
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(purple)

                Button("Confirm Location") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .foregroundColor(.white)
                .background(purple)
                .cornerRadius(12)
                .padding(.bottom)
            } else {
                Text("Drag map to select location")
                    .padding()
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(purple.opacity(0.7))
            }
        }
    }
}

struct AddMemoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddMemoryView()
            .environmentObject(MemoryStore())
    }
}

