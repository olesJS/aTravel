//
//  Item+CoreDataProperties.swift
//  aTravel
//
//  Created by Олексій Якимчук on 28.08.2023.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var about: String?
    @NSManaged public var type: String?
    @NSManaged public var date: Date?
    @NSManaged public var rating: Int16
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var id: UUID?
    @NSManaged public var image: NSSet?
    
    public var wrappedName: String {
        name ?? "Unknown Name"
    }
    
    public var wrappedID: UUID {
        id ?? UUID()
    }
    
    public var wrappedAbout: String {
        about ?? "Unknown About"
    }
    
    public var wrappedType: String {
        type ?? "No Type"
    }
    
    public var wrappedDate: Date {
        date ?? Date.now
    }
    
    public var dateString: String {
        wrappedDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    public var imagesArray: [CDImage] {
        let set = image as? Set<CDImage> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

}

// MARK: Generated accessors for image
extension Item {

    @objc(addImageObject:)
    @NSManaged public func addToImage(_ value: CDImage)

    @objc(removeImageObject:)
    @NSManaged public func removeFromImage(_ value: CDImage)

    @objc(addImage:)
    @NSManaged public func addToImage(_ values: NSSet)

    @objc(removeImage:)
    @NSManaged public func removeFromImage(_ values: NSSet)

}

extension Item : Identifiable {

}
