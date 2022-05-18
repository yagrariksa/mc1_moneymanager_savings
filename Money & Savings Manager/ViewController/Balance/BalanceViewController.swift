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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.sectionHeaderTopPadding = 0
        
        view.bringSubviewToFront(stackInfoView)
        view.bringSubviewToFront(separatorView)

        // Do any additional setup after loading the view.
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int.random(in: 2..<5)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "balanceHeader", for: indexPath) as! BalanceHeaderTableViewCell
            
            cell.dateLabel.text = "Mandiri"
            
            cell.incomeLabel.text = "Rp 200.000"
            cell.expenseLabel.text = "Rp 0"
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath)
            
            var content = cell.defaultContentConfiguration()
            
            content.text = "Account"
            
            let amount = Int.random(in: -100..<100)
            content.secondaryText = "Rp \(amount)"
            
            content.secondaryTextProperties.color = UIColor { (color) in
                if amount > 0 {
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
        tableView.deselectRow(at: indexPath, animated: false)
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
