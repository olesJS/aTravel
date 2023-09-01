//
//  AddedPlace.swift
//  aTravel
//
//  Created by Олексій Якимчук on 29.08.2023.
//

import Foundation

struct AddedPlace: Codable, Identifiable, Equatable {
    var name: String
    var isVisited: Bool = false
    
    var id = UUID()
    
    static func == (lhs: AddedPlace, rhs: AddedPlace) -> Bool {
        lhs.id == rhs.id
    }
}
