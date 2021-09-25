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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        myLabel.text = sentText
    }
    
    //create new cell and update table view
    func AddNewCell(title : String){
        items.append(Item(name: title))
        myTableView.beginUpdates()
        myTableView.insertRows(at: [IndexPath(row: items.count - 1, section: 0)], with: .automatic)
        myTableView.endUpdates()
    }
    
    //deselect row after being selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //show alert dialog when button is pressed
    @IBAction func callAlert(_ sender: Any) {
        let myAlert = UIAlertController(title: "Enter Title", message: "Enter title of the new list", preferredStyle: .alert)
        
        //add text field to get name of new item
        myAlert.addTextField{(thisTitle) in
            thisTitle.textAlignment = .center
            thisTitle.font = .systemFont(ofSize: 16)
            thisTitle.isSecureTextEntry = false
        }
        
        //user created new item
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
    //get size of items in list
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //create rows with the information of the list
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyItemsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myItemCell", for: indexPath) as! MyItemsTableViewCell
        
        cell.title.text = items[indexPath.row].name
        
        if items[indexPath.row].completed == true{
            cell.completedImage.image = UIImage(named: "greenNwhite")
        }
        else{
            cell.completedImage.image = UIImage(named: "unchecked-checkbox")
        }
         //placeholder image
        cell.completedImage.isUserInteractionEnabled = true
        cell.completedImage.tag = indexPath.row;
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        
        cell.completedImage.addGestureRecognizer(tapGestureRecognizer)
        return cell
    }
    
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        print("did tap image view", sender.view!.tag)
        let numRow = sender.view!.tag
        
        items[numRow].completed = !items[numRow].completed

        myTableView.beginUpdates()
        myTableView.reloadRows(at: [IndexPath(row: Int(numRow), section: 0)], with: .automatic)
        myTableView.endUpdates()
    }
   
}
