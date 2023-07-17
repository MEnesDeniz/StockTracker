//
//  SearchBarView.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 17.04.23.
//

import SwiftUI

struct SearchBarView: View {
    @ObservedObject var stockviewModel: StockViewModel // ViewModel for stocks
    @State private var isEditing = false // State variable to keep track of the editing state of the text field
    
    var body: some View {
        HStack {
            // Search text field
            TextField("Search...",
                      text: $stockviewModel.searchText,
                      onEditingChanged: editingChanged,
                      onCommit: {
                          UIApplication.shared.dismissKeyboard() // Dismiss the keyboard when the user presses enter
                      })
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        // Magnifying glass icon
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            // Clear search button
                            Button(action: {
                                self.stockviewModel.searchText = "" // Clear the search text in the view model
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
            
            if isEditing {
                // Cancel search button
                Button(action: cancelSearch) {
                    Text("Cancel") // Button label
                        .font(.custom("Roboto-Italic", size: 16)) // Set the font and size of the button label
                }
                .padding(.trailing, 10)
            }
        }
    }
    
    // Function called when the editing state of the text field changes
    private func editingChanged(isEditing: Bool) {
        self.isEditing = isEditing // Set the state variable to the editing state of the text field
    }

    // Function called when the cancel search button is pressed
    private func cancelSearch() {
        self.isEditing = false // Set the editing state to false
        self.stockviewModel.searchText = "" // Clear the search text in the view model
        UIApplication.shared.dismissKeyboard()
    }
}
