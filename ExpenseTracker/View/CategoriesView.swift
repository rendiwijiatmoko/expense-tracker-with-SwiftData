//
//  CategoriesView.swift
//  ExpenseTracker
//
//  Created by Rendi Wijiatmoko on 17/10/23.
//

import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Query(animation: .snappy) private var allCategories: [CategoryModel]
    @Environment(\.modelContext) private var context
    
    @State private var addCategory: Bool = false
    @State private var categoryName: String = ""
    
    @State private var deleteRequest: Bool = false
    @State private var requestedCategory: CategoryModel?
    var body: some View {
        NavigationStack {
            List {
                ForEach(allCategories.sorted(by: {($0.expense?.count ?? 0 ) > ($1.expense?.count ?? 0)})) { category in
                    DisclosureGroup {
                        if let expenses = category.expense, !expenses.isEmpty {
                            ForEach(expenses) { expense in
                                ExpenseCardView(expense: expense, displayTag: false)
                            }
                        } else {
                            ContentUnavailableView {
                                Label("No Expense", systemImage: "tray.fill")
                            }
                        }
                    } label: {
                        Text(category.categoryName)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            deleteRequest.toggle()
                            requestedCategory = category
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
            .navigationTitle("Categories")
            .overlay {
                if allCategories.isEmpty {
                    ContentUnavailableView {
                        Label("No Category", systemImage: "tray.fill")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addCategory.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.title3)
                    }

                }
            }
            .sheet(isPresented: $addCategory) {
                categoryName = ""
            } content: {
                NavigationStack {
                    List {
                        Section("Title") {
                            TextField("General", text: $categoryName)
                        }
                    }
                    .navigationTitle("Category Name")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") {
                                addCategory = false
                            }
                            .tint(.red)
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Add") {
                                let category = CategoryModel(categoryName: categoryName)
                                context.insert(category)
                                categoryName = ""
                                addCategory = false
                            }
                            .disabled(categoryName.isEmpty)
                        }
                    }
                }
                .presentationDetents([.height(180)])
                .presentationCornerRadius(20)
//                .interactiveDismissDisabled()
            }

        }
        .alert("If you delete a category, all the associated expenses will be deleted too.",
               isPresented: $deleteRequest) {
            Button(role: .destructive) {
                if let requestedCategory {
                    context.delete(requestedCategory)
                    self.requestedCategory = nil
                }
            } label: {
                Text("Delete")
            }
            
            Button(role: .cancel) {
                requestedCategory = nil
            } label: {
                Text("Cancel")
            }


        }
    }
}

#Preview {
    CategoriesView()
}
