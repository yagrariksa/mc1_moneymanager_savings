//
//  TransactionHandlerAppDelegateExtension.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 19/05/22.
//

import Foundation

extension AppDelegate {
    
    func generateTransactionDummy() {
        transactionList = [Transaction]()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let mf = DateFormatter()
        mf.dateFormat = "dd"
        
        guard let accountList = accountListDataSource,
              let expenseList = expenseCategoryDataSource,
              let incomeList = incomeCategoryDataSource else {return}
        
        for acc in accountList {
            let transaction = Transaction(
                type: "Income",
                accountUid: acc.uid,
                note: "MODIFIED BALANCE",
                amount: Int.random(in: 100..<1000) * 1000,
                uid: UUID().uuidString,
                targetUid: "MODIFIEDBALANCE",
                date: formatter.date(from: "2022/04/20 00:00")!
            )
            transactionList.append(transaction)
        }
        
        for _ in 0..<20 {
            
            
            let date = formatter.date(from: "2022/5/\(Int.random(in: 1..<14)) \(Int.random(in: 1..<24)):\(Int.random(in: 1..<60))")
            
            let typeTransaction = ["Income","Expense","Transfer"].randomElement()!
            
            var targetUid = ""
            var accTransaction = accountList[Int.random(in: 0..<accountList.count)].uid
            
            if typeTransaction == "Income" {
                targetUid = incomeList[Int.random(in: 0..<incomeList.count)].uid
            }else if typeTransaction == "Expense" {
                targetUid = expenseList[Int.random(in: 0..<expenseList.count)].uid
            }else{
                repeat {
                    targetUid = accountList[Int.random(in: 0..<accountList.count)].uid
                }while accTransaction == targetUid
            }
            
            let transaction = Transaction(
                type: typeTransaction ,
                accountUid: accTransaction,
                note: "Note",
                amount: Int.random(in: 1..<1000) * 1000, uid: UUID().uuidString,
                targetUid: targetUid,
                date: date!
            )
            
            transactionList.append(transaction)
        }
        
        transactionList.sort(by: {$0.date < $1.date})
        
        dateTransactionListHelper = Array(Set(transactionList.map({$0.date.formatted(date: .numeric, time: .omitted)})))
        //        for i in transactionList {
        //            print(i.date)
        //        }
        //        print("transaction count : \(transactionList.count)")
    }
    
    func updateTransactionGroupDataSource() {
        transactionGroupList = [TransactionGroup]()
        
        //        refactor this code
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let dateMaker = DateFormatter()
        dateMaker.dateFormat = "yyyy/MM/dd"
        
        for i in dateTransactionListHelper {
            let data = transactionList.filter {$0.date.formatted(date: .numeric, time: .omitted) == i}
            
            if data.count > 0 {
                transactionGroupList.append(TransactionGroup(date: data[0].date, list: data, income: countIncome(data), expense: countExpense(data)))
            }
        }
        
        transactionGroupList.sort(by: {$0.date > $1.date})
    }
    
    func countIncome(_ data: [Transaction]) -> Int {
        var count = 0
        for transaction in data.filter({$0.type == "Income"}) {
            count+=transaction.amount
        }
        return count
    }
    
    func countExpense(_ data: [Transaction]) -> Int {
        var count = 0
        for transaction in data.filter({$0.type == "Expense"}) {
            count+=transaction.amount
        }
        return count
    }
    
    func countOverallTransaction() -> (i: Int, e:Int, t: Int) {
        var income = 0
        var expense = 0
        for t in transactionGroupList {
            income+=t.income
            expense+=t.expense
        }
        return (income, expense, income-expense)
    }
}
