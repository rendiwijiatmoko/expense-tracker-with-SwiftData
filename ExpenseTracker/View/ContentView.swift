//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Rendi Wijiatmoko on 17/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var currentTab: String = "Expenses"
    var body: some View {
        TabView(selection: $currentTab) {
            ExpensesView(currentTab: $currentTab)
                .tag("Expenses")
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Expenses")
                }
            CategoriesView()
                .tag("Category")
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("Category")
                }
        }
    }
}

#Preview {
    ContentView()
}
