//
//  ViewModel.swift
//  aTravel
//
//  Created by Олексій Якимчук on 28.08.2023.
//

import Foundation
import SwiftUI
import MapKit
import CoreData
import CoreLocation

enum LoadingStates {
    case loading, loaded, failed
}

@MainActor
class ViewModel: ObservableObject {
    @Published var items: [Item]
    let savePath = FileManager.documentDirectory.appendingPathExtension("Items")
    
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    
    @Published var isAddSheetActive = false
    
    let tripTypes = ["Visited", "Planned"]
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            items = try JSONDecoder().decode([Item].self, from: data)
        } catch {
            items = []
        }
    }
    
    // InfoView
    
    // AddView
    @Published var addName: String = ""
    @Published var addAbout: String = ""
    @Published var addDate: Date = Date.now
    @Published var addType: String = "Visited"
    
    // VisitedView
    let maximumRating = 5
    @Published var addRating = 3
    
    var isSaveButtonDisabled: Bool {
        if addName.replacingOccurrences(of: " ", with: "").count == 0 { return true }
        
        return false
    }
    
    // PlannedView
    @Published var places: [AddedPlace] = []
    
    @Published var newPlaceName: String = ""
    @Published var isPlaceVisited = false
    
    @Published var loadingState: LoadingStates = .loading
    @Published var pages = [Page]()
    
    // ImagePicker
    @Published var isImagePickerActive = false
    @Published var uiImage: UIImage?
    
    @Published var uiImageArray: [UIImage] = [UIImage]()
    
    // Saving new visited place
    func saveToDocumentDirectory() {
        // addding images
        var imgDataArray: [ImageData] = []
        for uiImg in uiImageArray {
            imgDataArray.append(ImageData(imgData: uiImg.jpegData(compressionQuality: 0.8) ?? Data()))
        }
        
        // creating a new example of Item
        let newItem = Item(name: addName, about: addAbout, type: addType, date: addDate, rating: addRating, location: Location(latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude), images: imgDataArray, addedPlaces: places)
        items.append(newItem)
        
        // writing data to Documents Directory
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("ERROR: SAVE VISITED")
        }
    }
    
    func cleanFields() {
        addName = ""
        addAbout = ""
        addDate = Date.now
        addType = "Planned"
        addRating = 3
        uiImageArray = [UIImage]()
        places = []
    }
    
    // deleting rows from check-list in PlannedView
    func removePlaceRows(at offsets: IndexSet) {
        places.remove(atOffsets: offsets)
    }
    
    // get the country of place
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> String {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        var countryName = ""
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Failed to retrieve address")
                return
            }
            
            if let placemarks = placemarks, let placemark = placemarks.first {
                countryName = placemark.country ?? "no country"
                print(placemark.country!)
                print("Country: \(placemark.country!)")
            } else {
                countryName = "No matching address"
            }
        })
        
        return countryName
    }
    
    // fetch places from Wikipedia
    func fetchNearbyPlaces(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(latitude)%7C\(longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        } catch {
            loadingState = .failed
        }
    }
}
