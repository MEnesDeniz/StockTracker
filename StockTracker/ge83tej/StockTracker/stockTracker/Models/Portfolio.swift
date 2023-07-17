//
//  Portfolio.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 14.04.23.
//

import Foundation

struct Portfolio: Identifiable {
    var id = UUID()
    var stocks: [Stock]?
    var analytics: Analytics
}
