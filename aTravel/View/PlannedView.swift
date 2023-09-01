//
//  PlannedView.swift
//  aTravel
//
//  Created by Олексій Якимчук on 28.08.2023.
//

import SwiftUI

struct PlannedView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Section {
            VStack {
                // Check-List
                VStack {
                    Text("Add places you'd like to visit:")
                        .bold()
                    
                    // added places
                    List {
                        ForEach(viewModel.places) { place in
                            HStack {
                                Text(place.name)
                                    .font(.title3)
                                    .padding(5)
                                
                                Spacer()
                            }
                            
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                    
                    // form for adding a new place
                    HStack {
                        TextField("Place name", text: $viewModel.newPlaceName)
                        
                        Button() {
                            viewModel.places.append(AddedPlace(name: viewModel.newPlaceName))
                            viewModel.newPlaceName = ""
                            print(viewModel.places)
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                        }
                        .disabled(viewModel.newPlaceName == "")
                    }
                }
                
                Divider()
                    .padding(.horizontal)
                
                Section {
                    Text("Places nearby:")
                        .padding(.bottom)
                        .bold()
                    
                    switch viewModel.loadingState {
                    case .loading:
                        VStack {
                            ProgressView()
                            Text("Loading...")
                        }
                        
                    case .failed:
                        Text("Please, try again later!")
                        
                    case .loaded:
                        VStack(alignment: .leading) {
                            ForEach(viewModel.pages, id: \.pageid) { page in
                                HStack {
                                    Text(page.title)
                                        .bold()
                                    + Text(": ")
                                    + Text(page.description)
                                        .italic()
                                    
//                                    Button() {
//                                        viewModel.places.append(AddedPlace(name: page.title))
//                                        viewModel.newPlaceName = ""
//                                        print(viewModel.places)
//                                    } label: {
//                                        Image(systemName: "plus.circle.fill")
//                                            .font(.title)
//                                    }
                                }
                                .onTapGesture {
                                    viewModel.places.append(AddedPlace(name: page.title))
                                    viewModel.newPlaceName = ""
                                    print(viewModel.places)
                                }
                                
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                // save button
                VStack(alignment: .center) {
                    Button() {
                        viewModel.saveToDocumentDirectory()
                        dismiss()
                        viewModel.cleanFields()
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Save")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isSaveButtonDisabled)
                }
            }
        }
        .task {
            await viewModel.fetchNearbyPlaces(latitude: viewModel.mapRegion.center.latitude, longitude: viewModel.mapRegion.center.longitude)
        }
    }
}

struct PlannedView_Previews: PreviewProvider {
    static var previews: some View {
        PlannedView()
    }
}
