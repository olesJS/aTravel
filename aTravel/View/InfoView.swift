//
//  InfoView.swift
//  aTravel
//
//  Created by Олексій Якимчук on 30.08.2023.
//

import SwiftUI
import MapKit

struct InfoView: View {
    @EnvironmentObject var viewModel: ViewModel
    let item: Item
    var itemCountry: String { // make it work
        viewModel.reverseGeocoding(latitude: item.location.latitude, longitude: item.location.longitude)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.yellow, .mint, .cyan], startPoint: .bottomTrailing, endPoint: .topLeading)
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    ZStack {
                        if item.type == "Visited" {
                            ScrollView(.horizontal) {
                                HStack(spacing: 5) {
                                    ForEach(item.images) { image in
                                        Image(uiImage: image.uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 250)
                                    }
                                }
                            }
                            .ignoresSafeArea()
                        }
                        
                        Map(coordinateRegion: .constant(MKCoordinateRegion(center: item.location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))), interactionModes: [])
                            .clipShape(Circle())
                            .frame(width: 200, height: 200)
                    }
                    
                    Text(item.name)
                        .font(.largeTitle.bold())
                    Text(itemCountry)
                    
                    if item.type == "Visited" {
                        Text("Visited: \(item.date.formatted(date: .abbreviated, time: .omitted))")
                            .font(.headline)
                    } else {
                        Text("Planned on: \(item.date.formatted(date: .abbreviated, time: .omitted))")
                            .font(.headline)
                    }
                    
                    if item.type == "Visited" {
                        VStack {
                            HStack {
                                ForEach(1..<viewModel.maximumRating + 1, id: \.self) { number in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(number <= item.rating ? Color.yellow : Color.gray)
                                }
                            }
                            
                            Text(item.rating == 1 ? "(1 star)" : "(\(item.rating) stars)")
                                .font(.caption)
                        }
                        .padding(.bottom)
                    }
                    
                    Text(item.about)
                    
                    // Add removing rows and checking
                    if item.type == "Planned" {
                        VStack {
                            ForEach(item.addedPlaces) { place in
                                HStack {
                                    Text(place.name)
                                    Spacer()
                                    Text(place.isVisited ? "Visited" : "Not visited")
                                        .foregroundColor(place.isVisited ? Color.green : Color.red)
                                }
                                Divider()
                                    .padding(.horizontal)
                            }
                            .frame(width: 300)
                        }
                        .padding()
                        .background(.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                
                Spacer()
            }
        }
        .navigationTitle("Info")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            NavigationLink {
                Text("EditView")
            } label: {
                Text("Edit")
            }
        }
    }
}
