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

@MainActor class ViewModel: ObservableObject {
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
}
