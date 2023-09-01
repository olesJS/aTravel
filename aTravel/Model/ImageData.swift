//
//  ImageData.swift
//  aTravel
//
//  Created by Олексій Якимчук on 29.08.2023.
//

import Foundation
import UIKit

struct ImageData: Codable, Identifiable {
    let imgData: Data
    var id = UUID()
    
    var uiImage: UIImage {
        UIImage(data: imgData) ?? UIImage()
    }
}
