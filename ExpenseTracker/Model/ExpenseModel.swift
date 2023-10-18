//
//  ExpenseModel.swift
//  ExpenseTracker
//
//  Created by Rendi Wijiatmoko on 17/10/23.
//

import SwiftUI
import SwiftData

@Model
class ExpenseModel {
    var title: String
    var subTitle: String
    var amount: Double
    var date: Date
    var category: CategoryModel?
    
    
    init(title: String, subTitle: String, amount: Double, date: Date, category: CategoryModel? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.amount = amount
        self.date = date
        self.category = category
    }
    
    @Transient
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(for: amount) ?? ""
    }
}
