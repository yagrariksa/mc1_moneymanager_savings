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
    
    var incomeCategoryDataSource: [IncomeCategory]?
    var expenseCategoryDataSource: [ExpenseCategory]?

    var transactionList: [Transaction] = [Transaction]()
    var transactionGroupList: [TransactionGroup] = [TransactionGroup]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("💙 didFinishLauncihng")
        loadAccountAndGroupDataSource()
        updateAccountAndGroupDataComplex()
        loadDataIncomeExcomeCategory()
        
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
                amount: Int.random(in: 100000..<1000000),
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
            
            if typeTransaction == "Income" {
                targetUid = incomeList[Int.random(in: 0..<incomeList.count)].uid
            }else if typeTransaction == "Expense" {
                targetUid = expenseList[Int.random(in: 0..<expenseList.count)].uid
            }else{
                targetUid = accountList[Int.random(in: 0..<accountList.count)].uid
            }
            
            let transaction = Transaction(
                type: typeTransaction ,
                accountUid: accountList[Int.random(in: 0..<accountList.count)].uid,
                note: "Note",
                amount: Int.random(in: 1000..<1000000), uid: UUID().uuidString,
                targetUid: targetUid,
                date: date!
            )
            
            transactionList.append(transaction)
        }
        
        transactionList.sort(by: {$0.date < $1.date})
        for i in transactionList {
            print(i.date)
        }
        print("transaction count : \(transactionList.count)")
    }
    
    func updateTransactionGroupDataSource() {
        transactionGroupList = [TransactionGroup]()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let dateMaker = DateFormatter()
        dateMaker.dateFormat = "yyyy/MM/dd"
        
        for i in 1..<14 {
            let data = transactionList.filter {Int(formatter.string(from: $0.date)) == i}
            
            if data.count > 0 {
                transactionGroupList.append(TransactionGroup(date: dateMaker.date(from: "2022/05/\(i)")!, list: data, income: countIncome(data), expense: countExpense(data)))
            }
        }
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



