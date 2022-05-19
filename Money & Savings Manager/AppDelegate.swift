//
//  AppDelegate.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 09/05/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //    bahan
    var accountList: [Account]?
    // call on
    
    var transactionList: [Transaction] = [Transaction]()
    var dateTransactionListHelper: [String] = [String]()
    
    //    datasource
    //    digunakan di viewcontroller
    var accountGroupDataSource: [AccountGroup]?
    // groupTableViewController
    
    var accountComplexDataSource: [ComplexDataSource] = [ComplexDataSource]()
    // accountListTableViewController
    
    var incomeCategoryDataSource: [IncomeCategory] = [IncomeCategory]()
    // incomeCategoryListTableViewController
    var expenseCategoryDataSource: [ExpenseCategory] = [ExpenseCategory]()
    // expenseCategoryListTableViewController
    
    var transactionGroupDataSource: [TransactionGroup] = [TransactionGroup]()
    // transactionListViewController
    
    var balanceGroupDataSource: [BalanceGroup] = [BalanceGroup]()
    // balanceViewController
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("💙 didFinishLauncihng")
        
        // load data from plist
        loadDataFromPlis()
        
        // prepare data for settings/account
        updateAccountDataComplex()
        
        // prepare data for transaction-page
        generateTransactionDummy()
        updateTransactionGroupDataSource()
        
        // prepare data for balance-page
        updateBalanceDataSource()
        
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
        print("💙 didDiscardSceneSessions")
    }
}

extension AppDelegate {
    func loadDataFromPlis()
    {
        // load data account
        // load data accoun-group
        loadAccountAndGroupFromPlist()
        
        // load data income-cat
        loadIncomeFromPlist()
        
        // load data expense-cat
        loadExpenseFromPlist()
        
        // load data transaction
    }
}




