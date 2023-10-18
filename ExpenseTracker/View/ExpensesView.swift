//
//  ExpensesView.swift
//  ExpenseTracker
//
//  Created by Rendi Wijiatmoko on 17/10/23.
//

import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Binding var currentTab: String
    /// Grouped Expenses Properties
    @Query(sort: [SortDescriptor(\ExpenseModel.date, order: .reverse)], animation: .snappy) private var allExpenses: [ExpenseModel]
    /// Grouped Expenses
    @State private var groupedExpenses:[GroupedExpenseModel] = []
    @State private var originalGroupedExpenses:[GroupedExpenseModel] = []
    @State private var addExpense: Bool = false
    @Environment(\.modelContext) private var context
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($groupedExpenses) { $group in
                    Section(group.groupTitle) {
                        ForEach(group.expenses) { expense in
                            ExpenseCardView(expense: expense)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        context.delete(expense)
                                        withAnimation {
                                            group.expenses.removeAll(where: {$0.id == expense.id})
                                            
                                            if group.expenses.isEmpty {
                                                groupedExpenses.removeAll(where: {$0.id == group.id})
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(.red)

                                }
                        }
                    }
                }
            }
            .navigationTitle("Expenses")
            .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: Text("Search"))
            .overlay {
                if allExpenses.isEmpty || groupedExpenses.isEmpty {
                    ContentUnavailableView {
                        Label("No Expense", systemImage: "tray.fill")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addExpense.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.title3)
                    }

                }
            }
        }
        .onChange(of: searchText, initial: true) { oldValue, newValue in
            if !newValue.isEmpty {
                filterExpenses(newValue)
            } else {
                groupedExpenses = originalGroupedExpenses
            }
        }
        .onChange(of: allExpenses, initial: true) { oldValue, newValue in
            if newValue.count > oldValue.count || groupedExpenses.isEmpty || currentTab == "Category" {
                createGroupedExpenses(newValue)
            }
        }
        .sheet(isPresented: $addExpense) {
            AddExpenseView()
//                .interactiveDismissDisabled()
        }
    }
    
    /// Filtering expenses
    func filterExpenses(_ text: String) {
        Task.detached(priority: .high) {
            let query = text.lowercased()
            let filteredExpanses = originalGroupedExpenses.compactMap { group -> GroupedExpenseModel? in
                let expenses = group.expenses.filter({$0.title.lowercased().contains(query)})
                if expenses.isEmpty {
                    return nil
                }
                return .init(date: group.date, expenses: expenses)
            }
            
            await MainActor.run {
                groupedExpenses = filteredExpanses
            }
        }
    }
    
    /// Creating Grouped Expenses (Grouping by Date)
    func createGroupedExpenses(_ expenses: [ExpenseModel]) {
        Task.detached(priority: .high) {
            let groupedDict = Dictionary(grouping: expenses) { expense in
                let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: expense.date)
                
                return dateComponents
            }
            
            /// Sorting Dictionary in Decending order
            let sortedDate = groupedDict.sorted {
                let calendar = Calendar.current
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                
                return calendar.compare(date1, to: date2, toGranularity: .day)  == .orderedDescending
            }
            
            /// Adding to the grouped expenses array
            /// UI Must be updated on  Main thread
            await MainActor.run {
                groupedExpenses = sortedDate.compactMap({ dict in
                    let date = Calendar.current.date(from: dict.key) ?? .init()
                    return .init(date: date, expenses: dict.value)
                })
                originalGroupedExpenses = groupedExpenses
            }
        }
    }
}

//#Preview {
//    ExpensesView(currentTab: "Category")
//}
