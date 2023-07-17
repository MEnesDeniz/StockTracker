//
//  PortfolioViewModel.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 14.04.23.
//

import Foundation
import os

class PortfolioViewModel: ObservableObject {
    var model: Model
    private let logger = Logger(subsystem: "com.enesdeniz.StockTracker", category: "PortfolioViewModel")

    init(model: Model) {
        self.model = model
    }
    
    //Add the stock to the portfolio
    func addToPortfolio(stock: Stock, entryPrice: Double, quantity: Double) {
        var item = stock
        item.entryPrice = entryPrice
        item.quantity = quantity
        model.user.portfolio.stocks?.append(item)
        logger.info("Added stock \(stock.symbol) to portfolio with entry price: \(entryPrice) and quantity: \(quantity)")
    }
    
    // Update the quantity of a given stock item with a new quantity
    func updateQuantity(for item: Stock, newQuantity: Double) {
        if let index = model.user.portfolio.stocks?.firstIndex(where: { $0.id == item.id }) {
            model.user.portfolio.stocks?[index].quantity = newQuantity
            logger.info("Updated quantity for stock \(item.symbol) to \(newQuantity)")
        }
    }

    // Update the current price of a given stock item with a new price
    func updateCurrentPrice(for item: Stock, newPrice: Double) {
        if let index = model.user.portfolio.stocks?.firstIndex(where: { $0.id == item.id }) {
            model.user.portfolio.stocks?[index].price = newPrice
            logger.info("Updated current price for stock \(item.symbol) to \(newPrice)")
        }
    }
    
    // Fetch the current price of a given stock item
    internal func fetchCurrentPrice(for item: Stock) async {
        let stock = await model.fetchWithTicker(withSymbol: item.symbol)
        guard let fetchedStock = stock else {
            logger.error("Failed to fetch current price for stock \(item.symbol)")
            return
        }
        guard let index = model.user.portfolio.stocks?.firstIndex(
            where: { $0.symbol == fetchedStock.symbol })
        else { return }
        
        DispatchQueue.main.async {
            self.model.user.portfolio.stocks?[index].price = Double(fetchedStock.price)
        }
        logger.info("Fetched current price for stock \(item.symbol): \(fetchedStock.price)")
    }
    
    // Remove a stock from the portfolio
    func removeStock(_ stock: Stock) {
        if let index = model.user.portfolio.stocks?.firstIndex(where: { $0.id == stock.id }) {
            model.user.portfolio.stocks?.remove(at: index)
        }
    }
    
    // Returns an array of stocks that are not already in the user's portfolio
    var possibleStocksToAdd: [Stock] {
        if let portfolioStocks = model.user.portfolio.stocks {
            let portfolioSymbols = portfolioStocks.map { $0.symbol }
            return model.stocks.filter { !portfolioSymbols.contains($0.symbol) }
        } else {
            return model.stocks
        }
    }
}
