//
//  Model.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 14.04.23.
//

// StockDataStore.swift

import Foundation
import os

// Define an enum for stock industries
enum StockIndustry: String {
    case technology = "Technology"
    case finance = "Finance"
    case infrastructure = "Infrastructure"
    case pharma = "Pharma"
}

class Model: ObservableObject {
    // Constants for API key and URL
    private enum Constants {
        static let apiKey = "cgs7qthr01qkrsgj4av0cgs7qthr01qkrsgj4avg"
        static let apiUrl = "https://finnhub.io/api/v1/quote"
    }
    
    private let logger = Logger(subsystem: "com.enesdeniz.StockTracker", category: "Model")

    // Published properties for stocks, error message, search text, and selected industry
    @Published var stocks: [Stock] = []
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var selectedIndustry: String?

    // Mock user
    @Published var user: User

    // Dictionary of industry and its corresponding stock symbols
    private let industryStocks = [
        StockIndustry.technology.rawValue: ["MSFT", "AAPL", "GOOGL", "AMZN", "TSLA"],
        StockIndustry.finance.rawValue: ["JPM", "BAC", "GS"],
        StockIndustry.infrastructure.rawValue: ["CAT", "MMM", "JCI"],
        StockIndustry.pharma.rawValue: ["JNJ", "PFE", "MRK"]
    ]

    init() {
        let analytics = Analytics(
            totalProfitOrLoss: 0,
            profitByIndustry: [String: Double](),
            stockDistribution: [String: Double]()
        )
        let portfolio = Portfolio(
            id: UUID(),
            stocks: [],
            analytics: analytics
        )
        let sampleUser = User(id: UUID(), username: "Admin", password: "Admin", portfolio: portfolio)
        user = sampleUser
    }

    // Fetch stocks using async/await
    func fetchStocks() async {
        // Clear stocks and error message before fetching
        DispatchQueue.main.async {
            self.stocks.removeAll()
            self.errorMessage = nil
        }
        logger.log("Fetching stocks...")

        await withTaskGroup(of: Stock?.self) { taskGroup in
            for (industry, symbols) in industryStocks {
                for symbol in symbols {
                    taskGroup.addTask { [weak self] in
                        return await self?.fetchStock(withSymbol: symbol, industry: industry)
                    }
                }
            }

            // Add fetched stock to the stocks array
            for await stock in taskGroup {
                if let stock = stock {
                    DispatchQueue.main.async {
                        self.stocks.append(stock)
                    }
                }
            }
        }
        logger.log("Stocks fetched successfully")
    }
    
    // Fetch a single stock using its symbol
    func fetchWithTicker(withSymbol symbol: String) async -> Stock? {
        logger.log("Fetching stock with symbol: \(symbol)")
        return await fetchStock(withSymbol: symbol, industry: StockIndustry.technology.rawValue)
    }

    // Fetch stock data from API
    private func fetchStock(withSymbol symbol: String, industry: String) async -> Stock? {
        guard let url = URL(string: "\(Constants.apiUrl)?symbol=\(symbol)&token=\(Constants.apiKey)") else {
            // Handle the error where the url is nil
            logger.error("Failed to create URL for stock with symbol: (symbol)")
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(StockAPIResponse.self, from: data)
            logger.log("Successfully fetched stock data for symbol: (symbol)")
            return response.toStock(withSymbol: symbol, industry: industry)
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = "Error fetching stock data: \(error.localizedDescription)"
            }
            logger.error("Error fetching stock data for symbol: (symbol) - (error.localizedDescription)")
            return nil
        }
    }
}

struct StockAPIResponse: Codable {
    let c: Double
    let d: Double
    let dp: Double

    func toStock(withSymbol symbol: String, industry: String) -> Stock {
        return Stock(symbol: symbol, price: c, change: d, percentChange: dp, industry: industry)
    }
}
