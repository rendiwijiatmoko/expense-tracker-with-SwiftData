//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Rendi Wijiatmoko on 17/10/23.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var title: String = ""
    @State private var subTitle: String = ""
    @State private var date: Date = .init()
    @State private var amount: CGFloat = 0
    @State private var category: CategoryModel?
    
    @Query(animation: .snappy) private var allCategories: [CategoryModel]
    var body: some View {
        NavigationStack {
            List {
                Section("Title") {
                    TextField("Magic keyboard", text: $title)
                }
                Section("Description") {
                    TextField("Bought a keyboard at apple store", text: $subTitle)
                }
                Section("Amount Spent") {
                    HStack(spacing: 4) {
                        Text("Rp")
                            .fontWeight(.semibold)
                        TextField("0.0", value: $amount, formatter: formatter)
                    }
                }
                Section("Date") {
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                
                if !allCategories.isEmpty {
                    HStack{
                        Text("Category")
                        Spacer()
                        Menu {
                            ForEach(allCategories) { category in
                                Button(category.categoryName) {
                                    self.category = category
                                }
                            }
                            
                            Button("None") {
                                self.category = nil
                            }
                        } label: {
                            if let categoryName = category?.categoryName {
                                Text(categoryName)
                            } else {
                                Text("None")
                            }
                        }

//                        Picker("", selection: $category) {
//                            ForEach(allCategories) {
//                                Text($0.categoryName)
//                                    .tag($0)
//                            }
//                        }
//                        .pickerStyle(.menu)
//                        .labelsHidden()
                    }
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.red)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        addExpense()
                    }
                    .disabled(isAddButtonDisable)
                }
            }
        }
    }
    
    var isAddButtonDisable: Bool {
        return title.isEmpty || subTitle.isEmpty || amount == .zero
    }
    
    private func addExpense() {
        let expense = ExpenseModel(title: title, subTitle: subTitle, amount: amount, date: date, category: category)
        context.insert(expense)
        dismiss()
    }
    
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

#Preview {
    AddExpenseView()
}
