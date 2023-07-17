//
//  StockView.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 17.04.23.
//

import SwiftUI

struct StockView: View {
    @State var stock: Stock
    
    var body: some View {
        VStack {
            HStack {
                Text(stock.symbol)
                    .font(.headline)
                    .padding(.bottom, 5)
                    .underline()
                Spacer()
            }
            
            HStack {
                Text("Price: \(String(format: "%.1f", stock.price))")
                    .fixedSize(horizontal: true, vertical: false)
                Spacer()
                
                HStack {
                    arrow(for: Double(stock.change))
                    Text("Change: \(String(format: "%.1f", stock.change))")
                        .fixedSize(horizontal: true, vertical: false)
                }
                
                Spacer()
                HStack {
                    arrow(for: Double(stock.change))
                    Text("Δ%: \(String(format: "%.1f", stock.percentChange))")
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
        }
    }
    
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
}
