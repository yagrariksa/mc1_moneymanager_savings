//
//  AccountGroup.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 09/05/22.
//

import Foundation

struct AccountGroup: Codable, Equatable {
    var name: String
    var uid: String
    
    static func ==(lhs: AccountGroup, rhs: AccountGroup) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    static func getPath() -> URL {
        let documentsDirectory : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL: URL = documentsDirectory.appendingPathComponent("account_group").appendingPathExtension("plist")
        return archiveURL
    }
    
    static func saveData(_ groups: [AccountGroup])
    {
        
        let propertyListEncoder = PropertyListEncoder()
        let encodedAccountGroup = try? propertyListEncoder.encode(groups)
        try? encodedAccountGroup?.write(to: getPath(), options: .noFileProtection)
    }
    
    
    static func loadData() -> [AccountGroup]?
    {
        let propertyListDecoder = PropertyListDecoder()
        if let retrivedData = try? Data(contentsOf: getPath()) {
            if let decodedAccountGroup = try? propertyListDecoder.decode(Array<AccountGroup>.self, from: retrivedData){
                return decodedAccountGroup
            }
        }
        return nil
    }
    
    static func seed() -> [AccountGroup] {
        return [
            AccountGroup(name: "Cash", uid: UUID().uuidString),
            AccountGroup(name: "Card", uid: UUID().uuidString),
            AccountGroup(name: "Debit Card", uid: UUID().uuidString),
            AccountGroup(name: "Savings", uid: UUID().uuidString),
            AccountGroup(name: "Investment", uid: UUID().uuidString),
            AccountGroup(name: "Loan", uid: UUID().uuidString),
            AccountGroup(name: "Insurance", uid: UUID().uuidString)
        ]
    }
}
