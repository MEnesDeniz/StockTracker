//
//  MainContentView.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 17.04.23.
//

import SwiftUI


struct MainContentView: View {
    @EnvironmentObject private var model: Model


    @State private var selectedTab = 1

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            TabView(selection: $selectedTab) {
                NavigationView {
                    BrowseView(stockviewModel: StockViewModel(model: model))
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Browse")
                }
                .tag(1)

                NavigationView {
                    PortfolioView(portfolioViewModel: PortfolioViewModel(model: model))
                }
                .tabItem {
                    Image(systemName: "briefcase")
                    Text("Portfolio")
                }
                .tag(2)

                NavigationView {
                    AnalyticsView(viewModel: AnalyticsViewModel(model: model))
                }
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Analytics")
                }
                .tag(3)
            }
        }
    }
}
