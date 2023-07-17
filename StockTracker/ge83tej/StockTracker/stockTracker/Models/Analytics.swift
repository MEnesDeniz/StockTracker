//
//  Analytics.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 17.04.23.
//

import Foundation

struct Analytics {
    var totalProfitOrLoss: Double?
    var profitByIndustry: [String: Double] = [:]
    var stockDistribution: [String: Double] = [:]
}
