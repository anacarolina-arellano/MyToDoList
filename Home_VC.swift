//
//  Home_VC.swift
//  MyToDoList
//
//  Created by Ana Carolina Arellano Alvarez on 05/09/21.
//

import UIKit

class Home_VC: UIViewController {

    //@IBOutlet weak var myScrollview : UIScrollView!
    @IBOutlet weak var myTableView : UITableView!
    @IBOutlet weak var myButtonAddCell : UIButton!
    
    var listNames = ["Tap Here","iOS Assignment", "Project Dev to-do", "Shopping list"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
    }


    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func AddNewCell(title : String){
        listNames.append(title)
        myTableView.beginUpdates()
        myTableView.insertRows(at: [IndexPath(row: listNames.count - 1, section: 0)], with: .automatic)
        myTableView.endUpdates()
    }
    @IBAction func callAlert(_ sender: Any) {
        let myAlert = UIAlertController(title: "Enter Title", message: "Enter title of the new list", preferredStyle: .alert)
        
        myAlert.addTextField{(thisTitle) in
            thisTitle.textAlignment = .center
            thisTitle.font = .systemFont(ofSize: 16)
            thisTitle.isSecureTextEntry = false
        }
         
        let okAction = UIAlertAction(title: "Ok", style: .default){
            (myAlertAction) in
            let newTitle = myAlert.textFields![0].text!
            self.AddNewCell(title: newTitle)
        }
        
        myAlert.addAction(okAction)
        myAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
}

extension Home_VC: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNames.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyCustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCellID", for: indexPath) as! MyCustomTableViewCell
        
        cell.title.text = listNames[indexPath.row]
        cell.numItems.text = "# Items"
        return cell
    }
}


extension Home_VC: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete)
        {
            listNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete \(listNames[indexPath.row])?"
    }
}
