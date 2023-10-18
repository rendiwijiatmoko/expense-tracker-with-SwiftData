//
//  CategoryModel.swift
//  ExpenseTracker
//
//  Created by Rendi Wijiatmoko on 17/10/23.
//

import SwiftUI
import SwiftData

@Model
class CategoryModel {
    var categoryName: String
    @Relationship(deleteRule: .cascade, inverse: \ExpenseModel.category)
    var expense: [ExpenseModel]?
    
    init(categoryName: String) {
        self.categoryName = categoryName
    }
}
