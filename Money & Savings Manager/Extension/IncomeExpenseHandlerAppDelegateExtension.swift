//
//  IncomeExpenseHandlerAppDelegateExtension.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 19/05/22.
//

import Foundation

extension AppDelegate {
    func updateIncome(_ income: IncomeCategory) {
        if let index = incomeCategoryDataSource?.firstIndex(where: {$0.uid == income.uid}) {
            incomeCategoryDataSource?[index] = income
            saveIncome()
        }
    }
    
    func updateExpense(_ expense: ExpenseCategory) {
        if let index = expenseCategoryDataSource?.firstIndex(where: {$0.uid == expense.uid}) {
            expenseCategoryDataSource?[index] = expense
            saveIncome()
        }
    }
    
    func saveIncome() {
        guard let income = incomeCategoryDataSource else {return}
        IncomeCategory.saveData(income)
    }
    
    func saveExpense() {
        guard let expense = expenseCategoryDataSource else {return}
        ExpenseCategory.saveData(expense)
    }
    
    func addIncome(_ income: IncomeCategory) {
        incomeCategoryDataSource?.append(income)
        saveIncome()
    }
    
    func addExpense(_ expense: ExpenseCategory) {
        expenseCategoryDataSource?.append(expense)
        saveExpense()
    }
    
    func deleteIncome(_ uid: String) {
        if let index = incomeCategoryDataSource?.firstIndex(where: {$0.uid == uid}) {
            incomeCategoryDataSource?.remove(at: index)
            saveIncome()
        }
    }
    
    func deleteExpense(_ uid: String) {
        if let index = expenseCategoryDataSource?.firstIndex(where: {$0.uid == uid}){
            expenseCategoryDataSource?.remove(at: index)
            saveExpense()
        }
    }
    
    func loadDataIncomeExcomeCategory() {
        if let income = IncomeCategory.loadData() {
            incomeCategoryDataSource = income
        }else{
            incomeCategoryDataSource = IncomeCategory.seed()
        }
        
        if let expense = ExpenseCategory.loadData() {
            expenseCategoryDataSource = expense
        }else{
            expenseCategoryDataSource = ExpenseCategory.seed()
        }
    }
    
}
