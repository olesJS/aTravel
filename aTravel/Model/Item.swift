//
//  Item.swift
//  aTravel
//
//  Created by Олексій Якимчук on 29.08.2023.
//

import Foundation

struct Item: Codable, Identifiable {
    var id = UUID()
    
    let name: String
    let about: String
    let type: String
    let date: Date
    var rating: Int
    let location: Location
    var images: [ImageData]
}
