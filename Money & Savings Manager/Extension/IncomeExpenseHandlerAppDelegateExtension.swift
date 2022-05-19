//
//  IncomeExpenseHandlerAppDelegateExtension.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 19/05/22.
//

import Foundation

extension AppDelegate {
    // income
    func addIncome(_ income: IncomeCategory) {
        incomeCategoryDataSource.append(income)
        saveIncome()
    }
    
    func updateIncome(_ income: IncomeCategory) {
        if let index = incomeCategoryDataSource.firstIndex(where: {$0.uid == income.uid}) {
            incomeCategoryDataSource[index] = income
            saveIncome()
        }
    }
    
    func deleteIncome(_ uid: String) {
        if let index = incomeCategoryDataSource.firstIndex(where: {$0.uid == uid}) {
            incomeCategoryDataSource.remove(at: index)
            saveIncome()
        }
    }
    
    
    // expense
    func addExpense(_ expense: ExpenseCategory) {
        expenseCategoryDataSource.append(expense)
        saveExpense()
    }
    
    func updateExpense(_ expense: ExpenseCategory) {
        if let index = expenseCategoryDataSource.firstIndex(where: {$0.uid == expense.uid}) {
            expenseCategoryDataSource[index] = expense
            saveIncome()
        }
    }
    
    func deleteExpense(_ uid: String) {
        if let index = expenseCategoryDataSource.firstIndex(where: {$0.uid == uid}){
            expenseCategoryDataSource.remove(at: index)
            saveExpense()
        }
    }
    
    
    // save to plist
    func saveIncome() {
        IncomeCategory.saveData(incomeCategoryDataSource)
        // update transactionList
    }
    
    func saveExpense() {
        ExpenseCategory.saveData(expenseCategoryDataSource)
        //  update transactionList
    }
    
    
    // load from plist
    func loadIncomeFromPlist() {
        if let income = IncomeCategory.loadData() {
            incomeCategoryDataSource = income
        }else{
            incomeCategoryDataSource = IncomeCategory.seed()
        }
    }
    
    func loadExpenseFromPlist() {
        if let expense = ExpenseCategory.loadData() {
            expenseCategoryDataSource = expense
        }else{
            expenseCategoryDataSource = ExpenseCategory.seed()
        }
    }
    
}
