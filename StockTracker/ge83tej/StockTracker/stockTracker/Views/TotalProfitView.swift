//
//  TotalProfitView.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 17.04.23.
//

import SwiftUI

struct TotalProfitView: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    @State private var isProfitVisible = false

    // Computed property to get the total profit or loss from the analytics
    private var totalProfitOrLoss: Double {
        return viewModel.model.user.portfolio.analytics.totalProfitOrLoss ?? 0
    }

    // Computed property to get the color of the profit or loss depending on its value
    private var profitColor: Color {
        if totalProfitOrLoss > 0 { // If profit is positive, use green color
            return .green
        } else if totalProfitOrLoss < 0 { // If profit is negative, use red color
            return .red
        } else { // If profit is zero, use gray color
            return .gray
        }
    }

    var body: some View {
        VStack {
            HStack {
                Text("Total Profit/Loss")
                    .font(.title)
                Spacer() // Add a spacer to push the button to the right
                Button(action: {
                    isProfitVisible.toggle() // Toggle the visibility of the profit
                }) {
                    Image(systemName: isProfitVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom)
            .frame(maxWidth: .infinity, alignment: .center)

            if isProfitVisible { // If profit is visible, show the value
                Text("$" + String(format: "%.2f", totalProfitOrLoss))
                    .font(.largeTitle)
                    .foregroundColor(profitColor)
            } else { // If profit is not visible, show an eye icon with slash
                Image(systemName: "eye.slash")
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center) // Set the frame width to maximum and center align
    }
}
