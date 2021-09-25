//
//  Home_VC.swift
//  MyToDoList
//
//  Created by Ana Carolina Arellano Alvarez on 05/09/21.
//

import UIKit

class Home_VC: UIViewController {

    @IBOutlet weak var myTableView : UITableView!
    @IBOutlet weak var myButtonAddCell : UIButton!
    var lists : Array<Group> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        //create placeholder data
        let itemOne = Item(name: "Task1, List 1")
        var itemTwo = Item(name: "Task2, List 1")
        itemTwo.completed = true;
        let itemOneL2 = Item(name: "Task1, List 2")
        let itemTwoL2 = Item(name: "Task2, List 2")
        let itemOneL3 = Item(name: "Task1, List 3")
        let itemTwoL3 = Item(name: "Task2, List 3")
        let itemThreeL3 = Item(name: "Task3, List 3")
        var itemFourL3 = Item(name: "Task4, List 3")
        itemFourL3.completed = true;
        let myItemsArray = [itemOne, itemTwo]
        let myItemsArrayL2 = [itemOneL2, itemTwoL2]
        let myItemsArrayL3 = [itemOneL3, itemTwoL3, itemThreeL3, itemFourL3]

        //add placeholder data to array
        lists.append(Group(name: "Tap Here", items: myItemsArray))
        lists.append(Group(name: "iOS Assignment", items: myItemsArrayL2))
        lists.append(Group(name: "Project dev", items: myItemsArrayL3))
        
    }
    
    //create new cell in table view
    func AddNewCell(title : String){
        let tempItems : Array<Item> = Array()
        let newGroup = Group(name: title, items: tempItems)
        lists.append(newGroup)
        //upodate table view
        myTableView.beginUpdates()
        myTableView.insertRows(at: [IndexPath(row: lists.count - 1, section: 0)], with: .automatic)
        myTableView.endUpdates()
    }
    
    //create alert dialog when user wants to create new list
    @IBAction func callAlert(_ sender: Any) {
        let myAlert = UIAlertController(title: "Enter Title", message: "Enter title of the new list", preferredStyle: .alert)
        
        //add field to receive text
        myAlert.addTextField{(thisTitle) in
            thisTitle.textAlignment = .center
            thisTitle.font = .systemFont(ofSize: 16)
            thisTitle.isSecureTextEntry = false
        }
         
        //retrieve the text entered
        let okAction = UIAlertAction(title: "Ok", style: .default){
            (myAlertAction) in
            let newTitle = myAlert.textFields![0].text!
            self.AddNewCell(title: newTitle)
        }
        
        myAlert.addAction(okAction)
        myAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
    //send data in segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ToItems")
        {
            let controller = segue.destination as! Items_VC
            let indexPath = sender as! MyCustomTableViewCell
            controller.sentText = indexPath.title.text!
            
            //find list that the user selected and send it to the Items_VC
            for list in lists{
                if list.name == indexPath.title.text!
                {
                    controller.items = list.items
                }
            }
        }
    }
}

extension Home_VC: UITableViewDataSource
{
    //get size of items in list
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    //create cells for the table view and show number of items
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyCustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCellID", for: indexPath) as! MyCustomTableViewCell
        
        cell.title.text = lists[indexPath.row].name
        cell.numItems.text = "\(String(lists[indexPath.row].items.count)) items"
        return cell
    }
}


extension Home_VC: UITableViewDelegate
{
    //deselect row after being selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //allow user to delete lists
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete)
        {
            lists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
        }
    }
    
    //show message to user when trying to delete a row
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete \(lists[indexPath.row])?"
    }
}
