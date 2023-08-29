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
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    let moc: NSManagedObjectContext
        
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    
    @Published var isAddSheetActive = false
    
    let tripTypes = ["Visited", "Planned"]
    
    // AddView
    @Published var addName: String = ""
    @Published var addAbout: String = ""
    @Published var addDate: Date = Date.now
    @Published var addType: String = "Planned"
    
    // VisitedView
    let maximumRating = 5
    @Published var addRating = 3
    
    var isSaveButtonDisabled: Bool {
        if addName.replacingOccurrences(of: " ", with: "").count == 0 { return true }
        
        return false
    }
    
    // ImagePicker
    @Published var isImagePickerActive = false
    @Published var uiImage: UIImage?
    
    @Published var uiImageArray: [UIImage] = [UIImage]()
    
    func saveVisited() {
        do {
            let newPlace = Item(context: moc)
            newPlace.id = UUID()
            newPlace.name = addName
            newPlace.about = addAbout
            newPlace.date = addDate
            newPlace.rating = Int16(addRating)
            newPlace.type = addType
            newPlace.latitude = mapRegion.center.latitude
            newPlace.longitude = mapRegion.center.longitude
            
            var cdImages = [CDImage]()
            
            for img in uiImageArray {
                let newCDImg = CDImage(context: moc)
                newCDImg.name = addName
                newCDImg.id = newPlace.id
                newCDImg.img = img.jpegData(compressionQuality: 0.8)
                cdImages.append(newCDImg)
            }
            
            newPlace.addToImage(NSSet(array: cdImages))
            try moc.save()
            print("moc saved visited")
            for i in items {
                print(i.name ?? "ae")
            }
        } catch {
            print("failed save")
        }
    }
}
