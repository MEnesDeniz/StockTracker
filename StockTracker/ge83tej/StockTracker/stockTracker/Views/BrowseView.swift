//
//  BrowseView.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 13.04.23.
//

import SwiftUI

struct BrowseView: View {
    @ObservedObject var stockviewModel = StockViewModel(model: Model())

    var body: some View {
        NavigationView {
            VStack {
                IndustrySelectionView(stockviewModel: stockviewModel)
                SearchBarView(stockviewModel: stockviewModel)
                
                if let errorMessage = stockviewModel.model.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    StockListView(stockviewModel: stockviewModel)
                }
            }
            .navigationBarTitle("Stocks", displayMode: .large)
        }
        .task {
            await stockviewModel.model.fetchStocks()
        }
    }
}

// Add this extension to dismiss the keyboard
extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
