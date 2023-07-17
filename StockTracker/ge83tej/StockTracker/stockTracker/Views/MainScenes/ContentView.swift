//
//  ContentView.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 17.04.23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = Model()
    @StateObject private var loginViewModel = LoginViewModel(model: Model())

    var body: some View {
        if loginViewModel.isAuthenticated {
            MainContentView()
                .environmentObject(loginViewModel)
                .environmentObject(model)
        } else {
            LoginView(viewModel: loginViewModel)
                .environmentObject(loginViewModel)
                .environmentObject(model)
        }
    }
}
