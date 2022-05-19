//
//  AccountHandlerAppDelegateExtension.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 19/05/22.
//

import Foundation

extension AppDelegate {
    func updateAccountGRoup(_ group: AccountGroup) {
        if let index = accountGroupDataSource?.firstIndex(where: {$0.uid == group.uid}) {
            accountGroupDataSource?[index] = group
            saveAccountGroup(accountGroupDataSource)
            updateAccountAndGroupDataComplex()
        }
    }
    
    func updateAccountAndGroupDataComplex() {
        updateDataComplex(accounts: accountListDataSource, groups: accountGroupDataSource)
    }
    
    func deleteAccount(uid: String) {
        if let index = accountListDataSource?.firstIndex(where: {$0.uid == uid}) {
            accountListDataSource?.remove(at: index)
            saveAccount(accountListDataSource)
            updateAccountAndGroupDataComplex()
        }
    }
    
    func deleteAccountGroup(uid: String) {
        if let index = accountGroupDataSource?.firstIndex(where: {$0.uid == uid}){
            accountGroupDataSource?.remove(at: index)
            saveAccountGroup(accountGroupDataSource)
            updateAccountAndGroupDataComplex()
        }
    }
    
    func updateDataComplex(data: [ComplexDataSource]) {
        self.complexDataSource = data
    }
    
    func updateAccount(_ account: Account) {
        if let index = accountListDataSource?.firstIndex(where: {$0.uid == account.uid}) {
            accountListDataSource?[index] = account
            saveAccount(accountListDataSource)
            updateAccountAndGroupDataComplex()
        }
    }
    
    func updateAccountAmount(_ uid: String, amount: Int){
        if let index = accountListDataSource?.firstIndex(where: {$0.uid == uid}) {
            accountListDataSource?[index].amount = amount
            updateAccountAndGroupDataComplex()
        }
    }
    
    
    func addAccount(_ account: Account) {
        accountListDataSource?.append(account)
        saveAccount(accountListDataSource)
        updateDataComplex(accounts: accountListDataSource, groups: accountGroupDataSource)
    }
    
    func addAccountGroup(_ group: AccountGroup) {
        accountGroupDataSource?.append(group)
        saveAccountGroup(accountGroupDataSource)
    }
    
    func saveAccount(_ accounts: [Account]?) {
        if let accounts = accounts {
            Account.saveData(accounts)
        }
    }
    
    func saveAccountGroup(_ groups: [AccountGroup]?) {
        if let groups = groups {
            AccountGroup.saveData(groups)
        }
    }
    
    // dipake buat GET data dari plist
    func loadAccountAndGroupDataSource() {
        if let dataAcc = Account.loadData(), let dataGroup = AccountGroup.loadData() {
            print("🤍 has Own Data")
            accountListDataSource = dataAcc
            accountGroupDataSource = dataGroup
        }else {
            let accountSeed = Account.seed()
            accountListDataSource = accountSeed.account
            accountGroupDataSource = accountSeed.group
            saveAccount(accountListDataSource)
            saveAccountGroup(accountGroupDataSource)
        }
        
    }
    
    // dipake buat update Data Complex untuk Data Source
    func updateDataComplex(accounts: [Account]?, groups: [AccountGroup]?) {
        complexDataSource = [ComplexDataSource]()
        if let groups = groups, let accounts = accounts {
            for group in groups {
                let filter = accounts.filter {$0.groupUid == group.uid}
                let data = ComplexDataSource(group: group, accounts: filter)
                complexDataSource.append(data)
            }
        }
        
    }
}
