//
//  LoginViewModel.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 15.04.23.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    var model: Model
    @Published var isAuthenticated = false


    init(model: Model) {
        self.model = model
    }
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?

    func login() {
        do {
            if username == model.user.username && password == model.user.password {
                isAuthenticated = true
            } else {
                throw LoginError.invalidCredentials
            }
        } catch LoginError.invalidCredentials {
            errorMessage = "Invalid credentials"
        } catch {
            errorMessage = "An unknown error occurred"
        }
    }
}


enum LoginError: Error {
    case invalidCredentials
}
