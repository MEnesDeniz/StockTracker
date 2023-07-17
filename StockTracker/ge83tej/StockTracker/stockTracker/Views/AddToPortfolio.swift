//
//  AddToPortfolio.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 14.04.23.
//

import SwiftUI

struct AddToPortfolioView: View {
    @ObservedObject var portfolioViewModel: PortfolioViewModel
    @Binding var showAddToPortfolio: Bool

    @State private var selectedStock: Stock?
    @State private var entryPrice: String = ""
    @State private var quantity: String = ""
    

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Picker("Select Stock", selection: $selectedStock) {
                        ForEach(portfolioViewModel.possibleStocksToAdd.sorted(by: { $0.symbol < $1.symbol })) { stock in
                            Text(stock.symbol).tag(stock as Stock?)
                        }
                    }
                    TextField("Entry Price", text: $entryPrice)
                        .keyboardType(.decimalPad)
                    TextField("Quantity", text: $quantity)
                        .keyboardType(.numberPad)
                }
                Button(action: {
                    addToPortfolio()
                }) {
                    Text("Add to Portfolio")
                }
            }
            .navigationTitle("Add Stock to Portfolio")
            .navigationBarItems(leading: Button("Cancel") {
                showAddToPortfolio = false
            })
        }
    }

    // Adds the selected stock with the entered entry price and quantity to the user's portfolio
    private func addToPortfolio() {
        guard let selectedStock = selectedStock,
              let entryPrice = Double(entryPrice),
              let quantity = Double(quantity) else {
            return
        }
        portfolioViewModel.addToPortfolio(stock: selectedStock, entryPrice: entryPrice, quantity: quantity)
        showAddToPortfolio = false
    }
}
