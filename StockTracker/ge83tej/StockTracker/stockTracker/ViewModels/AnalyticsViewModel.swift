//
//  AnalyticsViewModel.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 15.04.23.
//

import Foundation
import os.log

class AnalyticsViewModel: ObservableObject {
    var model: Model
    private let logger = Logger(subsystem: "com.enesdeniz.StockTracker", category: "AnalyticsViewModel")

    init(model: Model) { // Initialize an instance of AnalyticsViewModel with a given Model object
        self.model = model
    }
    
    private func calculateTotalProfit() -> Double { // Calculate the total profit or loss of the user's portfolio
        guard let stocks = model.user.portfolio.stocks else { // Check if there are any stocks in the user's portfolio
            return 0 // If not, return 0
        }
        // Calculate the total profit or loss by reducing the stocks array into a single value
        return stocks.reduce(into: 0) { result, stock in
            if let profit = stock.profitOrLoss { // Check if the profit or loss of the stock is not nil
                result += profit // Add the profit or loss to the result
            }
        }
    }
    
    // Calculate the total profit or loss by industry of the user's portfolio
    private func calculateProfitByIndustry() -> [String: Double] {
        guard let stocks = model.user.portfolio.stocks else { // Check if there are any stocks in the user's portfolio
            return [:] // If not, return an empty dictionary
        }

        var result = [String: Double]()
        stocks.forEach { stock in // Iterate over the stocks in the user's portfolio
            if let profit = stock.profitOrLoss { // Check if the profit or loss of the stock is not nil
                result[stock.industry, default: 0] += profit
            }
        }
        return result
    }
    
    // Calculate the stock distribution of the user's portfolio
    private func calculateStockDistribution() -> [String: Double] {
        guard let stocks = model.user.portfolio.stocks else { // Check if there are any stocks in the user's portfolio
            return [:] // If not, return an empty dictionary
        }
        var result = [String: Double]()
        let totalQuantity = stocks.reduce(into: 0) { result, stock in
            if let quantity = stock.quantity {
                result += quantity
            }
        }
        stocks.forEach { stock in // Iterate over the stocks in the user's portfolio
            if let quantity = stock.quantity {
                result[stock.symbol] = quantity / totalQuantity
            }
        }
        return result
    }
    
    func updateAnalytics() { // Update the analytics data in the user's portfolio with the calculated values
        let totalProfit = calculateTotalProfit()
        let profitByIndustry = calculateProfitByIndustry()
        let stockDistribution = calculateStockDistribution()
        model.user.portfolio.analytics = Analytics(
            totalProfitOrLoss: totalProfit,
            profitByIndustry: profitByIndustry,
            stockDistribution: stockDistribution
        )
        logger.info("Updated analytics data in the user's portfolio.")
    }
}
