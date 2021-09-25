//
//  Items_VC.swift
//  MyToDoList
//
//  Created by Ana Carolina Arellano Alvarez on 16/09/21.
//

import UIKit

class Items_VC: UIViewController, UITableViewDelegate {

    @IBOutlet weak var myTableView : UITableView!
    @IBOutlet weak var myButtonAddCell : UIButton!
    @IBOutlet weak var myLabel : UILabel!
    
    var sentText : String = ""
    var items: Array<Item> = Array()
    //public var itemNames = ["Task 1","Task 2", "Task 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        myLabel.text = sentText
    }
    
    func AddNewCell(title : String){
        var newItem = Item(name: title)
        items.append(newItem)
        myTableView.beginUpdates()
        myTableView.insertRows(at: [IndexPath(row: items.count - 1, section: 0)], with: .automatic)
        myTableView.endUpdates()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

extension Items_VC: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyItemsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myItemCell", for: indexPath) as! MyItemsTableViewCell
        
        //cell.title.text = "Name of List"
        cell.title.text = items[indexPath.row].name
        cell.completedImage.image = UIImage(named: "greenNwhite")
        return cell
    }
}
