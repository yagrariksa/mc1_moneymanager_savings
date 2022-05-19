//
//  AccountListTableViewController.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 09/05/22.
//

import UIKit

class AccountListTableViewController: UITableViewController, AddAccountTableViewControllerDelegate {
    
    func changeIndexPath(_ controller: AddAccountTableViewController, _ indexPath: Bool) {
        if !indexPath, let a = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: a, animated: false)
        }
    }
    
    var datasource: [ComplexDataSource] = [ComplexDataSource]()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updatedatasource()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func updatedatasource()
    {
        self.datasource = appDelegate.accountComplexDataSource
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
    
    @IBSegueAction func addEditAccount(_ coder: NSCoder, sender: Any?) -> AddAccountTableViewController? {
        
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            let accountToEdit = datasource[indexPath.section].accounts[indexPath.row]
            let a =  AddAccountTableViewController(coder: coder, account: accountToEdit)
            a?.delegate = self
            return a
        }else{
            return AddAccountTableViewController(coder: coder)
        }
    }
    
    @IBAction func unwindToAccountListTableView(segue: UIStoryboardSegue) {
        if segue.identifier == "AddAccountSsve",
           let sourceViewController = segue.source as? AddAccountTableViewController,
           let account = sourceViewController.account
        {
            if tableView.indexPathForSelectedRow != nil {
                appDelegate.updateAccount(account)
            }else{
                appDelegate.addAccount(account)
            }
            updatedatasource()
            tableView.reloadData()
        }
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].accounts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath)
        
        let data = datasource[indexPath.section].accounts[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = "\(data.name)"
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(datasource[section].group.name)"
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
     // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let acc = datasource[indexPath.section].accounts[indexPath.row]
            appDelegate.deleteAccount(uid: acc.uid)
            updatedatasource()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
