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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubviewToFront(monthViewContainer)
        view.bringSubviewToFront(moneyStackContainer)
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

extension TransactionListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int.random(in: 2..<5)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionHeader", for: indexPath) as! TransactionHeaderTableViewCell
            
            cell.dateLabel.text = "16"
            
            cell.dayLabel.text = "Sun"
            cell.dayLabel.textColor = UIColor.white
            
            cell.dayViewContainer.backgroundColor = UIColor.red
            cell.dayViewContainer.layer.cornerRadius = 4
            
            cell.incomeLabel.text = "Rp 200.000"
            cell.expenseLabel.text = "Rp 0"
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath)
            
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
    
    
}
