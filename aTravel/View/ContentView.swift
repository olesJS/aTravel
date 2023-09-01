//
//  ContentView.swift
//  aTravel
//
//  Created by Олексій Якимчук on 28.08.2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.items) { item in
                    //MapMarker(coordinate: item.location.coordinate, tint: item.type == "Visited" ? .blue : .red)
                    
                    MapAnnotation(coordinate: item.location.coordinate) {
                        NavigationLink {
                            InfoView(item: item)
                                .environmentObject(viewModel)
                        } label: {
                            VStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .font(.title2)
                                    .foregroundColor(item.type == "Visited" ? Color.blue : Color.red)
                                
                                Text(item.name)
                                    .font(.caption)
                                    .foregroundColor(item.type == "Visited" ? Color.blue : Color.red)
                            }
                        }
                    }
                }
                    .ignoresSafeArea()
                
                Circle()
                    .fill(.mint)
                    .opacity(0.4)
                    .frame(width: 28, height: 28)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            viewModel.isAddSheetActive = true
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                        .sheet(isPresented: $viewModel.isAddSheetActive) {
                            AddView()
                                .environmentObject(viewModel)
                        }
                    }
                }
            }
            .navigationTitle("aTravel📍")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
