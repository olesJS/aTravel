//
//  ViewModel.swift
//  aTravel
//
//  Created by Олексій Якимчук on 28.08.2023.
//

import Foundation
import SwiftUI
import MapKit

@MainActor class ViewModel: ObservableObject {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
}
