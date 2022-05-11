//
//  AppDelegate.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 09/05/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var accountGroupDataSource: [AccountGroup]?
    var accountListDataSource: [Account]?
    var complexDataSource: [ComplexDataSource] = [ComplexDataSource]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("💙 didFinishLauncihng")
        updateDataSource()
        updateDataComplex(accounts: accountListDataSource, groups: accountGroupDataSource)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        print("💙 configurationForConnecting")
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        debugPrint("💙 didDiscardSceneSessions")
    }

}

extension AppDelegate: PlistDataSourceProtocols {
    func updateDataComplex() {
        updateDataComplex(accounts: accountListDataSource, groups: accountGroupDataSource)
    }
    
    func deleteAccount(uid: String) {
        if let index = accountListDataSource?.firstIndex(where: {$0.uid == uid}) {
            accountListDataSource?.remove(at: index)
            saveAccount(accountListDataSource)
            updateDataComplex()
        }
    }
    
    func deleteAccountGroup(uid: String) {
        if let index = accountGroupDataSource?.firstIndex(where: {$0.uid == uid}){
            accountGroupDataSource?.remove(at: index)
            saveAccountGroup(accountGroupDataSource)
            updateDataComplex()
        }
    }
    
    func updateDataComplex(data: [ComplexDataSource]) {
        self.complexDataSource = data
    }
    
    func updateAccount(_ account: Account) {
        if let index = accountListDataSource?.firstIndex(where: {$0.uid == account.uid}) {
            accountListDataSource?[index] = account
            saveAccount(accountListDataSource)
            updateDataComplex()
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
    func updateDataSource() {
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

