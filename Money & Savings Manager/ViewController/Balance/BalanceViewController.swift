//
//  BalanceViewController.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 13/05/22.
//

import UIKit

class BalanceViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var separatorView: UIView!
    
    @IBOutlet var stackInfoView: UIStackView!
    
    @IBOutlet var accountAmountLabel: UILabel!
    @IBOutlet var liabilitiesAmountLabel: UILabel!
    @IBOutlet var totalAmountLabel: UILabel!
    
    
    var datasource: [BalanceGroup] = [BalanceGroup]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datasource = appDelegate.balanceGroupDataSource
        
        setupAmountInfo()
        // Do any additional setup after loading the view.
    }
    
    func setupAmountInfo() {
        let a = datasource.filter {$0.amount > 0}.map({$0.amount}).reduce(0, +)
        let b = datasource.filter {$0.amount < 0}.map({$0.amount}).reduce(0, -)
        
        accountAmountLabel.text = "\(Transaction.moneyToString(a))"
        liabilitiesAmountLabel.text = "\(Transaction.moneyToString(b))"
        totalAmountLabel.text = "\(Transaction.moneyToString(a-b))"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailBalance",
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell){
            let uid = datasource[indexPath.section].acc[indexPath.row - 1].uid
            let vc = segue.destination as! BalanceDetailViewController
            vc.uid = uid
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

extension BalanceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].acc.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "balanceHeader", for: indexPath) as! BalanceHeaderTableViewCell
            
            let source = datasource[indexPath.section]
            
            cell.dateLabel.text = "\(source.group.name)"
            
            cell.balanceLabel.text = "\(Transaction.moneyToString(source.amount))"
            
            cell.balanceLabel.textColor = UIColor { (color) in
                if source.amount > 0 {
                    return .systemBlue
                }else{
                    return .systemRed
                }
                
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath)
            
            let source = datasource[indexPath.section].acc[indexPath.row - 1]
            
            var content = cell.defaultContentConfiguration()
            
            content.text = "\(source.name)"
            
            content.secondaryText = "\(Transaction.moneyToString(source.amount ?? 0))"
            
            content.secondaryTextProperties.color = UIColor { (color) in
                if source.amount ?? 1 > 0 {
                    return .systemBlue
                }else{
                    return .systemRed
                }
                
            }
            
            cell.contentConfiguration = content
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 35
        }
        return 43
    }
    
}
