//
//  PlistDataSourceProtocols.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 11/05/22.
//

import Foundation

protocol PlistDataSourceProtocols {
    func addAccount(_ account: Account)
    func addAccountGroup(_ group: AccountGroup)
    
    func updateDataSource()
    
    func saveAccount(_ accounts: [Account]?)
    func saveAccountGroup(_ groups: [AccountGroup]?)
    
    func deleteAccount(uid: String)
    func deleteAccountGroup(uid: String)
    
    func updateDataComplex(accounts: [Account]?, groups: [AccountGroup]?)
    func updateDataComplex()
    func updateDataComplex(data: [ComplexDataSource])
    func updateAccount(_ account: Account)
}
