//
//  AddedPlace.swift
//  aTravel
//
//  Created by Олексій Якимчук on 29.08.2023.
//

import Foundation

struct AddedPlace: Codable, Identifiable {
    var name: String
    var isVisited: Bool = false
    
    var id = UUID()
}
