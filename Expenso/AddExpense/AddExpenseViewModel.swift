//
//  AddExpenseViewModel.swift
//  Expenso
//
//  Created by Sameer Nawaz on 31/01/21.
//

import Foundation
import CoreData

class AddExpenseViewModel: ObservableObject {
    
    var expenseObj: ExpenseCD?
    
    @Published var title = ""
    @Published var amount = ""
    @Published var occuredOn = Date()
    @Published var note = ""
    @Published var typeTitle = "Income"
    @Published var tagTitle = getTransTagTitle(transTag: TRANS_TAG_TRANSPORT)
    @Published var showTypeDrop = false
    @Published var showTagDrop = false
    
    @Published var selectedType = TRANS_TYPE_INCOME
    @Published var selectedTag = TRANS_TAG_TRANSPORT
    
    @Published var alertMsg = String()
    @Published var showAlert = false
    @Published var closePresenter = false
    
    init() {  }
    
    func getButtText() -> String {
        if selectedType == TRANS_TYPE_INCOME { return "\(expenseObj == nil ? "ADD" : "EDIT") INCOME" }
        else if selectedType == TRANS_TYPE_EXPENSE { return "\(expenseObj == nil ? "ADD" : "EDIT") EXPENSE" }
        else { return "\(expenseObj == nil ? "ADD" : "EDIT") TRANSACTION" }
    }
    
    func saveTransaction(managedObjectContext: NSManagedObjectContext) {
        
        let titleStr = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let amountStr = amount.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if titleStr.isEmpty || titleStr == "" {
            alertMsg = "Enter Title"; showAlert = true
            return
        }
        
        if amountStr.isEmpty || amountStr == "" {
            alertMsg = "Enter Amount"; showAlert = true
            return
        }
        
        guard let amount = Double(amountStr) else {
            alertMsg = "Enter valid number"; showAlert = true
            return
        }
        
        let expense: ExpenseCD
        if expenseObj != nil { expense = expenseObj! }
        else {
            expense = ExpenseCD(context: managedObjectContext)
            expense.createdAt = Date()
        }
        expense.updatedAt = Date()
        expense.type = selectedType
        expense.title = titleStr
        expense.tag = selectedTag
        expense.occuredOn = occuredOn
        expense.note = note
        expense.amount = amount
        do {
            try managedObjectContext.save()
            closePresenter = true
        } catch { alertMsg = "\(error)"; showAlert = true }
    }
    
    func deleteTransaction(managedObjectContext: NSManagedObjectContext) {
        guard let expenseObj = expenseObj else { return }
        managedObjectContext.delete(expenseObj)
        do {
            try managedObjectContext.save(); closePresenter = true
        } catch { alertMsg = "\(error)"; showAlert = true }
    }
}