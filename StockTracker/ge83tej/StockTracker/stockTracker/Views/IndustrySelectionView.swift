//
//  IndustrySelectionView.swift
//  StockTracker
//
//  Created by Deniz, Muhammed Enes on 17.04.23.
//

import SwiftUI

struct IndustrySelectionView: View {
    @ObservedObject var stockviewModel: StockViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Industry.allCases, id: \.self) { industry in // Loop through all cases of the Industry enum
                    Button(action: {
                        stockviewModel.selectedIndustry = stockviewModel.selectedIndustry == industry ? nil : industry
                    }) {
                        Text(industry.rawValue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(stockviewModel.selectedIndustry == industry ?
                                        Color.blue : colorScheme == .dark ?
                                        // Set the background color of the button based on the selected industry and color scheme
                                        Color.gray.opacity(0.7) : Color.gray.opacity(0.3))
                            .foregroundColor(stockviewModel.selectedIndustry == industry ? .white :
                                                // Set the text color of the button based on the selected industry and color scheme
                                                colorScheme == .dark ? .white : .black)
                            .cornerRadius(8) // Add some corner radius to the button
                            .scaleEffect(stockviewModel.selectedIndustry == industry ? 1.1 : 1.0)
                            .animation(.spring(), value: stockviewModel.selectedIndustry == industry)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
