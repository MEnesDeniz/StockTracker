//
//  User.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 15.04.23.
//

import Foundation

struct User {
    var id: UUID
    var username: String
    var password: String
    var portfolio: Portfolio
}
