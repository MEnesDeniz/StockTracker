//
//  Charts.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 17.04.23.
//

import SwiftUI
import SwiftUICharts
import SwiftPieChart

struct ProfitDistributionBarChartView: View {
    @ObservedObject var viewModel: AnalyticsViewModel

    // Computed property to get the profit data by industry for bar chart
    private var barChartData: [(String, Double)] {
        viewModel.model.user.portfolio.stocks?.reduce(into: [String: Double]()) { result, item in
            let industry = item.industry
            if let profit = item.profitOrLoss {
                result[industry, default: 0] += profit
            }
        }
        .map { ($0.key, $0.value) } ?? []
    }

    var body: some View {
        VStack {
            Text("Profit Distribution by Industry")
                .font(.title)
                .padding(.bottom)

            BarChartView(
                data: ChartData(values: barChartData), // Pass the chart data as a parameter
                title: "Profit Distribution", // Title for the chart
                legend: "Industries" // Legend for the chart
            )
            .frame(height: 300) // Set the height of the chart
        }
    }
}

// Computed property to get the portfolio data for pie chart
struct PortfolioDistributionPieChartView: View {
    @ObservedObject var viewModel: AnalyticsViewModel
    var colorScheme: ColorScheme

    private var pieChartData: [PieChartItem] {
        viewModel.model.user.portfolio.stocks?.compactMap { item in
            if let quantity = item.quantity {
                return PieChartItem(value: quantity, name: item.symbol, color: Color.random)
            } else {
                return nil
            }
        } ?? []
    }

    var body: some View {
        let isLightMode = colorScheme == .light

        VStack {
            Text("Portfolio Distribution")
                .font(.title)
                .padding(.top)

            PieChartView(
                values: pieChartData.map { $0.value }, // Pass the values as an array
                names: pieChartData.map { $0.name }, // Pass the names as an array
                formatter: { value in String(format: "%.0f", value) }, // A closure to format the values
                colors: pieChartData.map { $0.color }, // Pass the colors as an array
                backgroundColor: isLightMode ? .white : .black, // Set the background color based on the color scheme
                widthFraction: 0.5, // Set the width fraction of the chart
                innerRadiusFraction: 0.5, // Set the inner radius fraction of the chart
                textColor: isLightMode ? .black : .white // Set the text color based on the color scheme
            )
            .frame(height: 300)
            .padding(.bottom)
            .id(UUID()) // Force the PieChartView to update when the data changes
        }
    }
}

struct PieChartItem {
    let value: Double
    let name: String
    let color: Color
}

// MARK: - Color+Random
extension Color {
    static var random: Color {
        var color: Color
        repeat {
            color = Color(
                red: Double.random(in: 0...1),
                green: Double.random(in: 0...1),
                blue: Double.random(in: 0...1)
            )
        } while color == .white
        return color
    }
}
