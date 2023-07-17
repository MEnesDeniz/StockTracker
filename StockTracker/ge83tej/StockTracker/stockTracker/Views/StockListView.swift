//
//  StockListView.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 17.04.23.
//

import SwiftUI

struct StockListView: View {
    @ObservedObject var stockviewModel: StockViewModel
    
    private func arrow(for value: Double) -> some View {
        let imageName: String
        let color: Color
        
        if value > 0 {
            imageName = "arrow.up"
            color = .green
        } else if value < 0 {
            imageName = "arrow.down"
            color = .red
        } else {
            imageName = "arrow.up.and.down"
            color = .gray
        }
        
        return Image(systemName: imageName)
            .foregroundColor(color)
            .font(.footnote)
    }
    
    var stockList: some View {
        List(stockviewModel.filteredStocks().sorted(by: { $0.symbol < $1.symbol })) { stock in
            StockView(stock: stock)
        }
        .clipped()
    }
    
    var body: some View {
        stockList
    }
}
