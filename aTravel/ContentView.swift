//
//  ContentView.swift
//  aTravel
//
//  Created by Олексій Якимчук on 28.08.2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @StateObject var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel(moc: moc))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.items) { item in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)) {
                        VStack {
                            Image(systemName: "mappin")
                                .foregroundColor(item.type == "Visited" ? Color.green : Color.red)
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
