//
//  AnalyticsView.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 17.04.23.
//

import SwiftUI
import SwiftPieChart
import SwiftUICharts

struct AnalyticsView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: AnalyticsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                TotalProfitView(viewModel: viewModel)
                    .padding(.bottom, 8)
                Divider()
                    .padding(.horizontal)

                ProfitDistributionBarChartView(viewModel: viewModel)
                    .padding(.bottom, 8)
                Divider()
                    .padding(.horizontal)

                PortfolioDistributionPieChartView(viewModel: viewModel, colorScheme: colorScheme)
            }
            .padding(.top, 16)
        }
        .onAppear {
            viewModel.updateAnalytics()
        }
    }
}
