//
//  GroupedExpenseModel.swift
//  ExpenseTracker
//
//  Created by Rendi Wijiatmoko on 17/10/23.
//

import SwiftUI

struct GroupedExpenseModel: Identifiable {
    var id: UUID = .init()
    var date: Date
    var expenses: [ExpenseModel]
    
    var groupTitle: String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            return date.formatted(date: .abbreviated, time: .omitted)
        }
    }
}
