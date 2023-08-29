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
                // To-Do list
                // Add places to Item struct
                VStack {
                    Text("Add places you'd like to visit:")
                        .bold()
                    
                    List {
                        ForEach(viewModel.places) { place in
                            Text(place.name)
                                .font(.title3)
                                .padding(5)
                            
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                    
                    HStack {
                        TextField("Place name", text: $viewModel.newPlaceName)
                        
                        Button() {
                            viewModel.places.append(AddedPlace(name: viewModel.newPlaceName))
                            viewModel.newPlaceName = ""
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                        }
                        .disabled(viewModel.newPlaceName == "")
                    }
                }
                
                Divider()
                    .padding(.horizontal)
                
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
    }
}

struct PlannedView_Previews: PreviewProvider {
    static var previews: some View {
        PlannedView()
    }
}
