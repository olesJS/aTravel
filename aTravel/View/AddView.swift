//
//  AddView.swift
//  aTravel
//
//  Created by Олексій Якимчук on 28.08.2023.
//

import SwiftUI

struct AddView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Text("Add place")
                    .font(.title.bold())
                
                Spacer()
                
                Button("Cancel") {
                    dismiss()
                    viewModel.cleanFields()
                }
            }
            .padding()
            
            Spacer()
            
            Form {
                Section {
                    TextField("Name", text: $viewModel.addName)
                    VStack(alignment: .leading) {
                        Text("Description:")
                            .font(.callout.bold())
                        TextEditor(text: $viewModel.addAbout)
                            .frame(width: 300, height: 150)
                    }
                    DatePicker("Date of your trip:", selection: $viewModel.addDate, displayedComponents: .date)
                    Picker("Type of your trip:", selection: $viewModel.addType) {
                        ForEach(viewModel.tripTypes, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    if viewModel.addType == "Planned" {
                        PlannedView()
                            .environmentObject(viewModel)
                    } else {
                        VisitedView()
                            .environmentObject(viewModel)
                    }
                }
            }
        }
    }
}
