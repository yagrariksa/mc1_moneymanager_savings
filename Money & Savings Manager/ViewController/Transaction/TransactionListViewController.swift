//
//  TransactionListViewController.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 13/05/22.
//

import UIKit

class TransactionListViewController: UIViewController {

    @IBOutlet var monthViewContainer: UIView!
    @IBOutlet var moneyStackContainer: UIStackView!
    @IBOutlet var separatorView: UIView!
    
    @IBOutlet var incomeOverallLabel: UILabel!
    @IBOutlet var expenseOverallLabel: UILabel!
    @IBOutlet var totalOverallLabel: UILabel!
    
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var accountList: [Account] = [Account]()
    var expenseList: [ExpenseCategory] = [ExpenseCategory]()
    
    var incomeList: [IncomeCategory] = [IncomeCategory]()
    
    var transactionGroupList: [TransactionGroup] = [TransactionGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubviewToFront(monthViewContainer)
        view.bringSubviewToFront(moneyStackContainer)
        view.bringSubviewToFront(separatorView)
        
        if let data = appDelegate?.accountListDataSource {
            accountList = data
        }
        
        if let income = appDelegate?.incomeCategoryDataSource {
            incomeList = income
        }
        
        if let expense = appDelegate?.expenseCategoryDataSource {
            expenseList = expense
        }
        
        appDelegate?.generateTransactionDummy()
        appDelegate?.updateTransactionGroupDataSource()
        
        if let transaction = appDelegate?.transactionGroupList {
            transactionGroupList = transaction
        }
        
        if let data = appDelegate?.countOverallTransaction() {
            incomeOverallLabel.text = "\(Transaction.moneyToString(data.i))"
            expenseOverallLabel.text = "\(Transaction.moneyToString(data.e))"
            totalOverallLabel.text = "\(Transaction.moneyToString(data.t))"
        }
    }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TransactionListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionGroupList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionGroupList[section].list.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionHeader", for: indexPath) as! TransactionHeaderTableViewCell
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            let tanggal = Int(dateFormatter.string(from: transactionGroupList[section].date))!
            cell.dateLabel.text = "\(tanggal)"
            
          
            let fCalendar = Calendar.current.component(.weekday, from: transactionGroupList[section].date)
            cell.dayLabel.text = "\(DateFormatter().weekdaySymbols[fCalendar - 1])"
            
            
            cell.dayLabel.textColor = UIColor.white
            
            if fCalendar == 1 {
                cell.dayViewContainer.backgroundColor = UIColor.systemRed
            }else if fCalendar == 7 {
                cell.dayViewContainer.backgroundColor = UIColor.systemBlue
            }else{
                cell.dayViewContainer.backgroundColor = UIColor.systemGray
            }
            
            cell.dayViewContainer.layer.cornerRadius = 4
            
            cell.incomeLabel.text = "\(Transaction.moneyToString(transactionGroupList[section].income))"
            cell.expenseLabel.text = "\(Transaction.moneyToString(transactionGroupList[section].expense))"
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionTableViewCell
            
            let data = transactionGroupList[section].list[row-1]
        
            let clockFormatter = DateFormatter()
            clockFormatter.dateFormat = "HH:mm"
            
            
            cell.noteLabel.text = data.note
            cell.clockLabel.text = clockFormatter.string(from: data.date)
            let acc = accountList.first(where: {$0.uid == data.accountUid})?.name
            cell.accountLabel.text = acc
            cell.amountLabel.text = "\(Transaction.moneyToString(data.amount))"
            switch data.type {
            case "Income":
                cell.typeLabel.text = incomeList.first(where: {$0.uid == data.targetUid})?.name
                cell.amountLabel.textColor = UIColor.systemBlue
                
            case "Expense":
                cell.typeLabel.text = expenseList.first(where: {$0.uid == data.targetUid})?.name
                cell.amountLabel.textColor = UIColor.systemRed
                
            default:
                cell.typeLabel.text = "Transfer"
                let penerima = accountList.first(where: {$0.uid == data.targetUid})?.name
                cell.accountLabel.text = "\(acc!) -> \(penerima!)"
                cell.amountLabel.textColor = UIColor.secondaryLabel
                
            }
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}

struct TransactionGroup {
    var date: Date
    var list: [Transaction]
    var income: Int
    var expense: Int
}
