//
//  ExpenseCardView.swift
//  ExpenseTracker
//
//  Created by Rendi Wijiatmoko on 17/10/23.
//

import SwiftUI

struct ExpenseCardView: View {
    @Bindable var expense: ExpenseModel
    var displayTag:  Bool = true
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Text(expense.title)
                Text(expense.subTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                if let categoryName = expense.category?.categoryName, displayTag {
                    Text(categoryName)
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 4)
                        .background(.red.gradient, in:.capsule)
                }
            }
            .lineLimit(1)
            
            Spacer(minLength: 5)
            
            Text(expense.currencyString)
                .font(.subheadline.bold())
            
        }
    }
}

#Preview {
    ExpenseCardView(expense: ExpenseModel(title: "Judul", subTitle: "Subjudul", amount: 2.00, date: .init()))
}
