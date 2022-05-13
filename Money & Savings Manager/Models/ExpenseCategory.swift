//
//  ExpenseCategory.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 09/05/22.
//

import Foundation

struct ExpenseCategory: Codable, Equatable {
    var name: String
    var uid: String
    
    static func ==(lhs: ExpenseCategory, rhs: ExpenseCategory) -> Bool{
        return lhs.uid == rhs.uid
    }
    
    static func getPath() -> URL {
        let documentsDirectory : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL: URL = documentsDirectory.appendingPathComponent("expense_category_list").appendingPathExtension("plist")
        return archiveURL
    }
    
    static func saveData(_ income: [ExpenseCategory])
    {
        let propertyListEncoder = PropertyListEncoder()
        let encodedAccounts = try? propertyListEncoder.encode(income)
        try? encodedAccounts?.write(to: ExpenseCategory.getPath(), options: .noFileProtection)
    }
    
    
    static func loadData() -> [ExpenseCategory]?
    {
        let propertyListDecoder = PropertyListDecoder()
        if let retrivedData = try? Data(contentsOf: getPath()) {
            if let decodedExpense = try? propertyListDecoder.decode(Array<ExpenseCategory>.self, from: retrivedData){
                return decodedExpense
            }
        }
        return nil
    }
    
    static func seed() -> [ExpenseCategory] {
        return [
            ExpenseCategory(name: "Food", uid: UUID().uuidString),
            ExpenseCategory(name: "Transportation", uid: UUID().uuidString),
            ExpenseCategory(name: "Household", uid: UUID().uuidString),
            ExpenseCategory(name: "Self-Development", uid: UUID().uuidString),
            ExpenseCategory(name: "Social Life", uid: UUID().uuidString),
            ExpenseCategory(name: "Apparel", uid: UUID().uuidString),
            ExpenseCategory(name: "Culture", uid: UUID().uuidString),
            ExpenseCategory(name: "Health", uid: UUID().uuidString),
            ExpenseCategory(name: "Education", uid: UUID().uuidString),
        ]
    }
}
