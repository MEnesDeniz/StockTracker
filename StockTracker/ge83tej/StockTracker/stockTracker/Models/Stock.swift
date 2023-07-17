//
//  Stock.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 13.04.23.
//

import Foundation

struct Stock: Identifiable, Hashable {
    var id = UUID() // Add an id property
    var symbol: String
    var price: Double
    var change: Double
    var percentChange: Double
    var industry: String
    var entryPrice: Double?
    var quantity: Double?
    var profitOrLoss: Double? {
        guard let entryPrice = entryPrice, let quantity = quantity else {
            return nil
        }
        return (price - entryPrice) * Double(quantity)
    }
}
