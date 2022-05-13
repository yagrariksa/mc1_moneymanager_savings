//
//  Transaction.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 09/05/22.
//

import Foundation

struct Transaction: Codable, Equatable {
    var type: String
    var accountUid: String
    var note: String
    var amount: Int
    var uid: String
    var expenseCategoryUid: String
    var incomeCategoryUid: String
    var transferToUid: String
    var date: Date

    static func ==(lhs: Transaction, rhs: Transaction) -> Bool{
        return lhs.uid == rhs.uid
    }
    
    static func moneyFlow(trs: Transaction) -> Int{
        if trs.type == "Income" {
            return trs.amount
        }else {
            return -(trs.amount)
        }
    }
    
    static func getPath() -> URL {
        let documentsDirectory : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL: URL = documentsDirectory.appendingPathComponent("transaction_list").appendingPathExtension("plist")
        return archiveURL
    }
    
    static func saveData(data: [Transaction]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedTransaction = try? propertyListEncoder.encode(data)
        try? encodedTransaction?.write(to: Account.getPath(), options: .noFileProtection)
    }
    
    static func loadData() -> [Transaction]? {
        let propertyListDecoder = PropertyListDecoder()
        if let retrivedData = try? Data(contentsOf: getPath()) {
            if let decodedAccounts = try? propertyListDecoder.decode(Array<Transaction>.self, from: retrivedData){
                return decodedAccounts
            }
        }
        return nil
    }
    
    static func moneyToString(_ money: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "IDR"
        let uang = formatter.string(for: money) ?? "IDR 0"
        
        return "Rp \(uang[4...])"
    }
    
}
