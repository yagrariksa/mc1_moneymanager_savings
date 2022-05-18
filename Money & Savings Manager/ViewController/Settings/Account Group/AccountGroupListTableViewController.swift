//
//  AccountGroupListTableViewController.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 12/05/22.
//

import UIKit

class AccountGroupListTableViewController: UITableViewController, AddAccountGroupTableViewControllerDelegate {
    func doSomething(yes: Bool) {
        if yes, let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var groupList: [AccountGroup]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateGroupListDataSource()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func updateGroupListDataSource(){
        groupList = appDelegate.accountGroupDataSource
    }
    
    @IBSegueAction func editAccountGroup(_ coder: NSCoder, sender: Any?) -> AddAccountGroupTableViewController? {
        
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell), let group = groupList?[indexPath.row] {
            let vc = AddAccountGroupTableViewController(coder: coder, group: group)
            
            vc?.delegate = self
            return vc
        }else{
            return AddAccountGroupTableViewController(coder: coder)
        }
    }
    
    
    @IBAction func unwindToAccountGroupListTableView(segue: UIStoryboardSegue){
        guard segue.identifier == "saveAccountGroup",
              let vc = segue.source as? AddAccountGroupTableViewController,
              let group = vc.group else {return}
        
        if let indexPath = tableView.indexPathForSelectedRow {
            appDelegate.updateAccountGRoup(group)
            updateGroupListDataSource()
            tableView.reloadRows(at: [indexPath], with: .none)
        }else {
            appDelegate.addAccountGroup(group)
            updateGroupListDataSource()
            guard let row = groupList?.count else {
                tableView.reloadData()
                return
            }
            tableView.insertRows(at: [IndexPath(row: row-1, section: 0)], with: .none )
        }
        appDelegate.updateAccountAndGroupDataComplex()
    }
    
    
    @IBAction func editButtonTapped(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupList?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountGroupCell", for: indexPath)
        
        
        guard let data = groupList?[indexPath.row] else {return cell}
        
        var content = cell.defaultContentConfiguration()
        
        content.text = "\(data.name)"
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let uid = groupList?[indexPath.row].uid else {return}
            appDelegate.deleteAccountGroup(uid: uid)
            updateGroupListDataSource()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
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
