//
//  Transaction.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 09/05/22.
//

import Foundation

struct Transaction {
    var type: TransactionType
    var account: Account
    var accountUid: String
    var note: String
    var amount: Int
    var uid: String
    var expenseCategory: ExpenseCategory?
    var incomeCategory: IncomeCategory?
    var transferTo: Account?
}
