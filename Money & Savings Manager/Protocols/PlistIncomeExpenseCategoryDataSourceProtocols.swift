//
//  PlistIncomeExpenseCategoryDataSourceProtocols.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 12/05/22.
//

import Foundation


protocol PlisIncomeExpenseCategoryDataSourceProtocols {
    func saveIncome()
    func saveExpense()
    
    func addIncome(_ income: IncomeCategory)
    func addExpense(_ expense: ExpenseCategory)
    
    func updateIncome(_ income: IncomeCategory)
    func updateExpense(_ expense: ExpenseCategory)
    
    func deleteIncome(_ uid: String)
    func deleteExpense(_ uid: String)
    
    func loadData()
}
