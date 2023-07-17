//
//  StockViewModel.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 13.04.23.
//

import Foundation

// Enum with cases for different industries, and a stringValue property returning the raw value as a string.
enum Industry: String, CaseIterable {
    case technology = "Technology"
    case finance = "Finance"
    case infrastructure = "Infrastructure"
    case pharma = "Pharma"

    var stringValue: String {
        return rawValue
    }
}


class StockViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedIndustry: Industry?

    var model: Model

    init(model: Model) {
        self.model = model
    }

    //Filter the stocks by the selected industries
    func filteredStocks() -> [Stock] {
        return model.stocks.filter { stock in
            let matchesSearchText = searchText.isEmpty ? true : stock.symbol.localizedStandardContains(searchText)
            let matchesIndustry = selectedIndustry == nil ? true :
            stock.industry == selectedIndustry?.stringValue // Use stringValue property instead of rawValue
            return matchesSearchText && matchesIndustry
        }
    }
}
