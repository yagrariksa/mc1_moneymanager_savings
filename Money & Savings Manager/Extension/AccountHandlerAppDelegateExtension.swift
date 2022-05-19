//
//  AccountHandlerAppDelegateExtension.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 19/05/22.
//

import Foundation

extension AppDelegate {
    
    func addAccount(_ account: Account) {
        accountList?.append(account)
        saveAccount()
    }
    
    func updateAccount(_ account: Account) {
        if let index = accountList?.firstIndex(where: {$0.uid == account.uid}) {
            accountList?[index] = account
            saveAccount()
        }
    }
    
    // use in calculation
    func updateAccountAmount(_ uid: String, amount: Int){
        if let index = accountList?.firstIndex(where: {$0.uid == uid}) {
            accountList?[index].amount = amount
        }
    }
    
    func deleteAccount(uid: String) {
        if let index = accountList?.firstIndex(where: {$0.uid == uid}) {
            accountList?.remove(at: index)
            saveAccount()
        }
    }
    
    // account Group
    func addAccountGroup(_ group: AccountGroup) {
        accountGroupDataSource?.append(group)
        saveAccountGroup()
    }
    
    func updateAccountGRoup(_ group: AccountGroup) {
        if let index = accountGroupDataSource?.firstIndex(where: {$0.uid == group.uid}) {
            accountGroupDataSource?[index] = group
            saveAccountGroup()
        }
    }
    
    func deleteAccountGroup(uid: String) {
        if let index = accountGroupDataSource?.firstIndex(where: {$0.uid == uid}){
            accountGroupDataSource?.remove(at: index)
            saveAccountGroup()
        }
    }
    
    func saveAccount() {
        if let accounts = accountList {
            Account.saveData(accounts)
            updateAccountDataComplex()
//            update transactionList
//            update balanceGroupDataSource
        }
    }
    
    func saveAccountGroup() {
        if let groups = accountGroupDataSource {
            AccountGroup.saveData(groups)
            updateAccountDataComplex()
//            update balanceGroupDataSource
        }
    }
    
    func loadAccountAndGroupFromPlist() {
        if let dataAcc = Account.loadData(),let dataGroup = AccountGroup.loadData() {
            accountGroupDataSource = dataGroup
            accountList = dataAcc
        }else {
            let seed = Account.seed()
            accountList = seed.account
            saveAccount()
            accountGroupDataSource = seed.group
            saveAccountGroup()
        }
    }
    
    // dipake buat update Data Complex untuk Data Source
    func updateAccountDataComplex() {
        accountComplexDataSource = [ComplexDataSource]()
        if let groups = accountGroupDataSource,
           let accounts = accountList
        {
            for group in groups {
                let filter = accounts.filter {$0.groupUid == group.uid}
                let data = ComplexDataSource(group: group, accounts: filter)
                accountComplexDataSource.append(data)
            }
        }
        
    }
}
