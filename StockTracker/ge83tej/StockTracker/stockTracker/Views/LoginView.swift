//
//  LoginView.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 15.04.23.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            // Error message, if any
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.bottom)
            }

            // Login button
            Button(action: {
                viewModel.login()
            }) {
                Text("Login")
            }
            .padding()
        }
        .padding()
    }
}
