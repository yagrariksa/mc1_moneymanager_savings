//
//  AddAccountTableViewController.swift
//  Money & Savings Manager
//
//  Created by Daffa Yagrariksa on 09/05/22.
//

import UIKit

protocol AddAccountTableViewControllerDelegate: AnyObject {
    func changeIndexPath(_ controller: AddAccountTableViewController, _ indexPath: Bool)
}

class AddAccountTableViewController: UITableViewController {
    
    weak var delegate: AddAccountTableViewControllerDelegate?
    
    var account: Account?
    var accountGroupList: [AccountGroup] = [AccountGroup]()
    
    @IBOutlet var accountGroupTextField: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var noteTextField: UITextField!
    
    var accountGroupSelected: AccountGroup?
    
    @IBOutlet var saveBarButton: UIBarButtonItem!
    
    // FOR PICKER VIEW
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 4
    var selectedRow = 0
    
    @IBOutlet var accountGroupCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let accGroups = appDelegate.accountGroupDataSource else { return }
        accountGroupList = accGroups
        
        if let account = account {
            nameTextField.text = account.name
            accountGroupSelected = account.group
            title = "Edit Account"
            selectedRow = accountGroupList.firstIndex(where: {$0.uid == account.groupUid}) ?? 0
        }else{
            // DEBUG
            accountGroupSelected = accountGroupList[0]
            
            title = "Add Account"
        }
       
        updateAccountGroupTextField()
        updateSaveButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.changeIndexPath(self, false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "AddAccountSsve" else { return }
        
        guard let group = accountGroupSelected else {return}
        if account != nil {
            self.account?.name = nameTextField.text ?? ""
            self.account?.group = group
            self.account?.groupUid = group.uid
        }else{
            account = Account(name: nameTextField.text ?? "", uid: UUID().uuidString, group: group, groupUid: group.uid)
        }
        
    }
    
    init?(coder: NSCoder, account: Account) {
        self.account = account
        self.accountGroupSelected = account.group
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // show Picker View
    @IBAction func selectAccountGroup(_ sender: Any) {
        print("alert Picker")
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select Background Colour", message: "", preferredStyle: .actionSheet)
        
        alert.popoverPresentationController?.sourceView = accountGroupTextField
        alert.popoverPresentationController?.sourceRect = accountGroupTextField.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            
            self.accountGroupSelected = self.accountGroupList[self.selectedRow]
            self.updateAccountGroupTextField()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func validateInput(_ sender: Any) {
        updateSaveButton()
    }
    
    func updateSaveButton() {
        let group = accountGroupSelected?.name ?? ""
        let name = nameTextField.text ?? ""
        
        saveBarButton.isEnabled = !group.isEmpty && !name.isEmpty
    }
    
    func updateAccountGroupTextField() {
        accountGroupTextField.text = accountGroupSelected?.name
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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

extension AddAccountTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 20))
            label.text = accountGroupList[row].name
            label.sizeToFit()
            return label
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int
        {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
        {
            accountGroupList.count
        }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
        {
            return 40
        }
}
