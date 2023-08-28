//
//  CDImage+CoreDataProperties.swift
//  aTravel
//
//  Created by Олексій Якимчук on 28.08.2023.
//
//

import Foundation
import CoreData


extension CDImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDImage> {
        return NSFetchRequest<CDImage>(entityName: "CDImage")
    }

    @NSManaged public var img: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var item: Item?
    
    public var wrappedID: UUID {
        id ?? UUID()
    }
    
    public var wrappedName: String {
        name ?? "NoName"
    }

}

extension CDImage : Identifiable {

}
