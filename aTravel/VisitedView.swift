//
//  VisitedView.swift
//  aTravel
//
//  Created by Олексій Якимчук on 28.08.2023.
//

import SwiftUI

struct VisitedView: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        Section {
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        VStack {
                            Button() {
                                viewModel.isImagePickerActive = true
                            } label: {
                                VStack {
                                    Image(systemName: "photo.fill")
                                        .font(.largeTitle)
                                    Text("Add")
                                }
                            }
                        }
                        .frame(width: 100, height: 100)
                        .background(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        ForEach(viewModel.uiImageArray, id: \.self) { uiImage in
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140, height: 100)
                        }
                    }
                }
            }
            
            VStack {
                HStack {
                    Text("Rate the trip:")
                        .font(.callout).bold()
                    
                    Spacer()
                    
                    HStack {
                        ForEach(1..<viewModel.maximumRating + 1, id: \.self) { number in
                            Image(systemName: "star.fill")
                                .foregroundColor(number <= viewModel.addRating ? Color.yellow : Color.gray)
                                .onTapGesture {
                                    viewModel.addRating = number
                                    print(String(viewModel.addRating))
                                }
                        }
                    }
                }
                
                VStack(alignment: .center) {
                    Button() {
                        viewModel.saveVisited()
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
        .sheet(isPresented: $viewModel.isImagePickerActive) {
            ImagePicker(uiImage: $viewModel.uiImage)
        }
        .onChange(of: viewModel.uiImage) { _ in
            viewModel.uiImageArray.append(viewModel.uiImage ?? UIImage())
            print("Added UIImage")
            print(viewModel.uiImageArray)
        }
    }
}
