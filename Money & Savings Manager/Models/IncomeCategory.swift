//
//  IncomeCategory.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 09/05/22.
//

import Foundation

struct IncomeCategory: Codable, Equatable {
    var name: String
    var uid: String
    
    static func ==(lhs: IncomeCategory, rhs: IncomeCategory) -> Bool{
        return lhs.uid == rhs.uid
    }
    
    static func getPath() -> URL {
        let documentsDirectory : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL: URL = documentsDirectory.appendingPathComponent("income_category_list").appendingPathExtension("plist")
        return archiveURL
    }
    
    static func saveData(_ income: [IncomeCategory])
    {
        let propertyListEncoder = PropertyListEncoder()
        let encodedAccounts = try? propertyListEncoder.encode(income)
        try? encodedAccounts?.write(to: IncomeCategory.getPath(), options: .noFileProtection)
    }
    
    
    static func loadData() -> [IncomeCategory]?
    {
        let propertyListDecoder = PropertyListDecoder()
        if let retrivedData = try? Data(contentsOf: getPath()) {
            if let decodedIncome = try? propertyListDecoder.decode(Array<IncomeCategory>.self, from: retrivedData){
                return decodedIncome
            }
        }
        return nil
    }
    
    static func seed() -> [IncomeCategory] {
        return [
            IncomeCategory(name: "Salary", uid: UUID().uuidString),
            IncomeCategory(name: "Bonus", uid: UUID().uuidString),
            IncomeCategory(name: "Loan", uid: UUID().uuidString),
            IncomeCategory(name: "Investment", uid: UUID().uuidString),
            IncomeCategory(name: "Petty Cash", uid: UUID().uuidString),
            IncomeCategory(name: "Other", uid: UUID().uuidString),
        ]
    }
}
