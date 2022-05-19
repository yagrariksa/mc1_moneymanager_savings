//
//  BalanceHandlerAppDelegateExtension.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 19/05/22.
//

import Foundation

extension AppDelegate {
    func countBalance(){
        guard let list = accountList else {return}
        for acc in list {
            // find modif-balance
            let modifbal = transactionList.last(where: {$0.targetUid == "MODIFIEDBALANCE" && $0.accountUid == acc.uid
            })
            
            // REFACTOR-TODO : transaction after modifbal
            // find related transaction
            let outtrans = transactionList.filter {$0.accountUid == acc.uid && $0.targetUid != "MODIFIEDBALANCE"}
            
            let intrans = transactionList.filter {$0.targetUid == acc.uid && $0.type == "Transfer"}
            
            // do calculation
            guard let bal = modifbal else {return}
            var balance = bal.amount
            
            for i in outtrans {
                if i.type == "Income"{
                    balance += i.amount
                }else{
                    balance -= i.amount
                }
            }
            
            for i in intrans {
                balance += i.amount
            }
            // present value
            updateAccountAmount(acc.uid, amount: balance)
        }
    }
    
    func updateBalanceDataSource() {
        balanceGroupDataSource = [BalanceGroup]()
        countBalance()
        
        guard let groups = accountGroupDataSource, let accounts = accountList else {return}
        var amounts = 0
        for group in groups{
            let accs = accounts.filter {$0.groupUid == group.uid}
            
            amounts = accs.map({$0.amount ?? 0}).reduce(0, +)
            balanceGroupDataSource.append(BalanceGroup(group: group, acc: accs, amount: amounts))
            amounts = 0
        }
    }
}

struct BalanceGroup {
    var group: AccountGroup
    var acc: [Account]
    var amount: Int
}

extension AppDelegate {
    func getTransactionByAccountUid(uid: String) -> [TransactionGroup] {
        var data = [TransactionGroup]()
        
        let trans = transactionList.filter {$0.accountUid == uid || $0.targetUid == uid}
        
        let dateHelper = Array(Set(trans.map({$0.date.formatted(date: .numeric, time: .omitted)})))
        
        for date in dateHelper {
            let filteredTransaction = trans.filter {$0.date.formatted(date: .numeric, time: .omitted) == date}
            data.append(TransactionGroup(date: filteredTransaction[0].date, list: filteredTransaction, income: countIncome(filteredTransaction), expense: countExpense(filteredTransaction)))
        }
        
        data.sort(by: {$0.date > $1.date})
        
        return data
    }
}
