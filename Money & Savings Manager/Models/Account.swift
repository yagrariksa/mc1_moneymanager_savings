//
//  Account.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 09/05/22.
//

import Foundation

struct Account: Codable, Equatable {
    var name: String
    var uid: String
    var group: AccountGroup
    var groupUid: String
    var amount: Int?
    
    static func ==(lhs: Account, rhs: Account) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    static func getPath() -> URL {
        let documentsDirectory : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL: URL = documentsDirectory.appendingPathComponent("account_list").appendingPathExtension("plist")
        return archiveURL
    }
    
    static func saveData(_ accounts: [Account])
    {
        let propertyListEncoder = PropertyListEncoder()
        let encodedAccounts = try? propertyListEncoder.encode(accounts)
        print("save data : \(accounts.count)")
        try? encodedAccounts?.write(to: Account.getPath(), options: .noFileProtection)
    }
    
    
    static func loadData() -> [Account]?
    {
        let propertyListDecoder = PropertyListDecoder()
        if let retrivedData = try? Data(contentsOf: getPath()) {
            if let decodedAccounts = try? propertyListDecoder.decode(Array<Account>.self, from: retrivedData){
                return decodedAccounts
            }
        }
        return nil
    }
    
    static func seed() -> AccountSeed {
        let accountGroups = AccountGroup.seed()
        var accounts: [Account] = []
        for accountGroup in accountGroups {
            accounts.append(Account(name: accountGroup.name, uid: UUID().uuidString, group: accountGroup, groupUid: accountGroup.uid))
        }
        return AccountSeed(account: accounts, group: accountGroups)
    }
}

struct AccountSeed {
    var account: [Account]
    var group: [AccountGroup]
}
