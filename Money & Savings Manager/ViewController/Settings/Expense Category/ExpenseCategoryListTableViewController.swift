//
//  ExpenseCategoryListTableViewController.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 13/05/22.
//

import UIKit

class ExpenseCategoryListTableViewController: UITableViewController, AddExpenseCategoryTableViewControllerDelegate {
    func doSomething(yes: Bool) {
        if yes, let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var expenseList: [ExpenseCategory] = [ExpenseCategory]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateExpenseListDataSource()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func updateExpenseListDataSource() {
        if let data = appDelegate?.expenseCategoryDataSource {
            expenseList = data
        }
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
    
    @IBAction func unwindToExpenseCategoryListTableView(segue: UIStoryboardSegue){
        guard segue.identifier == "saveExpenseCategory",
              let vc = segue.source as? AddExpenseCategoryTableViewController,
        let expense = vc.expense else {return}
        
        if let indexPath = tableView.indexPathForSelectedRow {
            appDelegate?.updateExpense(expense)
            updateExpenseListDataSource()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }else{
            appDelegate?.addExpense(expense)
            updateExpenseListDataSource()
            tableView.insertRows(at: [IndexPath(row: expenseList.count-1, section: 0)], with: .none)
        }
    }
    
    @IBSegueAction func editExpenseCategory(_ coder: NSCoder, sender: Any?) -> AddExpenseCategoryTableViewController? {
            if let cell = sender as? UITableViewCell,
               let indexPath = tableView.indexPath(for: cell){
                let expense = expenseList[indexPath.row]
                let vc = AddExpenseCategoryTableViewController(coder: coder, expense: expense)
                
                vc?.delegate = self
                
                return vc
            }else{
                return AddExpenseCategoryTableViewController(coder: coder)
            }
           
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return expenseList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCategoryCell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        
        let data = expenseList[indexPath.row]
        
        content.text = data.name
        
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
            appDelegate?.deleteExpense(expenseList[indexPath.row].uid)
            updateExpenseListDataSource()
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
