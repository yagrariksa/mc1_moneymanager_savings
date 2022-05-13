//
//  TransactionTableViewCell.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 13/05/22.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
