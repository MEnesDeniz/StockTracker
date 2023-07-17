//
//  Portfolio.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 14.04.23.
//

import SwiftUI

struct PortfolioView: View {
    @ObservedObject var portfolioViewModel: PortfolioViewModel
    @State private var showAddToPortfolio = false
    
    var body: some View {
        VStack {
            // Show message if the portfolio is empty
            if let stocks = portfolioViewModel.model.user.portfolio.stocks, stocks.isEmpty {
                Text("Your portfolio is empty.")
                    .font(.custom("Comfortaa-Semibold", size: 24))
            } else {
                // Show the list of stocks in the portfolio
                List {
                    ForEach(portfolioViewModel.model.user.portfolio.stocks ?? []) { item in
                        HStack {
                            // Stock information
                            VStack(alignment: .leading) {
                                Text(item.symbol)
                                    .font(.headline)

                                // Entry price section
                                entryPriceSection(for: item)
                                
                                // Current price section
                                currentPriceSection(for: item)
                                
                                // Quantity section
                                quantitySection(for: item)
                            }
                            .task {
                                await portfolioViewModel.fetchCurrentPrice(for: item)
                            }

                            Spacer()

                            // Remove stock button
                            Button(action: {
                                portfolioViewModel.removeStock(item)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
        }
        // Add-to-portfolio sheet
        .sheet(isPresented: $showAddToPortfolio) {
            AddToPortfolioView(portfolioViewModel: portfolioViewModel,
                               showAddToPortfolio: $showAddToPortfolio
            )
        }
        .navigationBarTitle("Portfolio")
        .navigationBarItems(trailing: Button(action: {
            showAddToPortfolio = true
        }) {
            Image(systemName: "plus")
        })
    }
    
    // Entry price section view
    @ViewBuilder
    private func entryPriceSection(for item: Stock) -> some View {
        let textColor: Color = (item.entryPrice ?? 0) > item.price ? .red : .green

        HStack {
            Text("Entry Price:")
            Text("$")
            TextField("Entry Price", text: Binding(get: {
                if let entryPrice = item.entryPrice {
                    return String(entryPrice)
                } else {
                    return ""
                }
            }, set: { newValue in
                if newValue.isEmpty {
                    portfolioViewModel.model.user.portfolio.stocks?[getIndex(for: item)].entryPrice = 0.0
                } else if let newEntryPrice = Double(newValue) {
                    portfolioViewModel.model.user.portfolio.stocks?[getIndex(for: item)].entryPrice = newEntryPrice
                }
            }))
                .keyboardType(.decimalPad)
                .foregroundColor(textColor)
        }
        .padding(.vertical, 2)
    }
    
    // Quantity section view
    @ViewBuilder
     private func quantitySection(for item: Stock) -> some View {
         HStack {
             Text("Quantity:")
             TextField("Quantity", text: Binding(get: {
                 if let quantity = item.quantity {
                     return String(quantity)
                 } else {
                     return ""
                 }
             }, set: { newValue in
                 if newValue.isEmpty {
                     portfolioViewModel.model.user.portfolio.stocks?[getIndex(for: item)].quantity = 0.0
                 } else if let newQuantity = Double(newValue) {
                     portfolioViewModel.model.user.portfolio.stocks?[getIndex(for: item)].quantity = newQuantity
                 }
             }))
                 .keyboardType(.numberPad)
         }
         .padding(.vertical, 2)
     }

    @ViewBuilder
    private func currentPriceSection(for item: Stock) -> some View {
        let profitOrLoss = (item.quantity ?? 0) * (item.price - (item.entryPrice ?? 0))
        let textColor: Color = (item.entryPrice ?? 0) > item.price ? .red : .green

        HStack {
            Text("Current Price:")
            Text("$")
            Text("\(item.price, specifier: "%.2f")")
                .foregroundColor(textColor) // Add this line
            Spacer()
            Text("Profit/Loss: \(profitOrLoss, specifier: "%.2f")")
                .foregroundColor(profitOrLoss >= 0 ? .green : .red)
        }
    }
    
    private func getIndex(for item: Stock) -> Int {
        guard let stocks = portfolioViewModel.model.user.portfolio.stocks else {
            fatalError("Stocks array is nil in portfolioViewModel")
        }
        guard let index = stocks.firstIndex(where: { $0.id == item.id }) else {
            fatalError("Could not find index for item in portfolioViewModel")
        }
        return index
    }
}

extension NumberFormatter {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    static let number: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
