//
//  BalanceDetailViewController.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 18/05/22.
//

import UIKit

class BalanceDetailViewController: UIViewController {
    
    
    @IBOutlet var monthControlViewContainer: UIView!
    @IBOutlet var moneyInfoStackContainer: UIStackView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var incomeLabel: UILabel!
    @IBOutlet var expenseLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!
    
    @IBOutlet var mSeparator1: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var datasource: [TransactionGroup] = [TransactionGroup]()
    
    var accountList: [Account] = [Account]()
    var expenseList: [ExpenseCategory] = [ExpenseCategory]()
    
    var incomeList: [IncomeCategory] = [IncomeCategory]()
    
    var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let uid = uid else {
            return
        }
        
        loadDataHelper()
        
        if let titleLabel = appDelegate.accountList?.first(where: {$0.uid == uid})?.name {
            title = titleLabel
        }
        
        datasource = appDelegate.getTransactionByAccountUid(uid: uid)
        
        setupAmountInfo()
    }
    
    func setupAmountInfo() {
        let data = appDelegate.countOverallTransaction(transaction: datasource)
        incomeLabel.text = "\(Transaction.moneyToString(data.i))"
        expenseLabel.text = "\(Transaction.moneyToString(data.e))"
        totalLabel.text = "\(Transaction.moneyToString(data.t))"
    }
    
    init?(coder: NSCoder, uid: String) {
        super.init(coder: coder)
        self.uid = uid
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func loadDataHelper(){
        if let data = appDelegate.accountList {
            accountList = data
        }
        incomeList = appDelegate.incomeCategoryDataSource
        expenseList = appDelegate.expenseCategoryDataSource
        
        
        appDelegate.updateTransactionGroupDataSource()
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

extension BalanceDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].list.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionHeader", for: indexPath) as! TransactionHeaderTableViewCell
            
            let source = datasource[indexPath.section]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            let tanggal = Int(dateFormatter.string(from: source.date))!
            cell.dateLabel.text = "\(tanggal)"
            
            
            let fCalendar = Calendar.current.component(.weekday, from: source.date)
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
            
            cell.incomeLabel.text = "\(Transaction.moneyToString(source.income))"
            cell.expenseLabel.text = "\(Transaction.moneyToString(source.expense))"
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionTableViewCell
            
            let source = datasource[indexPath.section].list[indexPath.row - 1]
            
            let clockFormatter = DateFormatter()
            clockFormatter.dateFormat = "HH:mm"
            
            
            cell.noteLabel.text = source.note
            cell.clockLabel.text = clockFormatter.string(from: source.date)
            let acc = accountList.first(where: {$0.uid == source.accountUid})?.name
            cell.accountLabel.text = acc
            cell.amountLabel.text = "\(Transaction.moneyToString(source.amount))"
            switch source.type {
            case "Income":
                cell.typeLabel.text = incomeList.first(where: {$0.uid == source.targetUid})?.name
                cell.amountLabel.textColor = UIColor.systemBlue
                
            case "Expense":
                cell.typeLabel.text = expenseList.first(where: {$0.uid == source.targetUid})?.name
                cell.amountLabel.textColor = UIColor.systemRed
                
            default:
                cell.typeLabel.text = "Transfer"
                let penerima = accountList.first(where: {$0.uid == source.targetUid})?.name
                cell.accountLabel.text = "\(acc ?? "None") -> \(penerima ?? "None")"
                cell.amountLabel.textColor = UIColor.secondaryLabel
                
            }
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
