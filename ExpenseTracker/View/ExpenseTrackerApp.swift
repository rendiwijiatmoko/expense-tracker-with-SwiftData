//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Rendi Wijiatmoko on 17/10/23.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        /// Setting up the container
        .modelContainer(for: [ExpenseModel.self, CategoryModel.self])
    }
}
