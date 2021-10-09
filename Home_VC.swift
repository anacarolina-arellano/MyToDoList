//
//  Home_VC.swift
//  MyToDoList
//
//  Created by Ana Carolina Arellano Alvarez on 05/09/21.
//

import UIKit
let notificatonKey = "notifyChange"
let notificatonKeyCompletedItem = "notifyItemCompleted"
class Home_VC: UIViewController {

    @IBOutlet weak var myTableView : UITableView!
    @IBOutlet weak var myButtonAddCell : UIButton!
    var lists : Array<Group> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        //Set observer used to get new items
        NotificationCenter.default.addObserver(self,selector: #selector(ReceiveItem(_:)), name: Notification.Name(rawValue: notificatonKey), object: nil)
        //Set observer used to change completed status
        NotificationCenter.default.addObserver(self,selector: #selector(UpdateItem(_:)), name: Notification.Name(rawValue: notificatonKeyCompletedItem), object: nil)
        //read file
        read()
        
    }
    
    //Get newly added item
    @objc func ReceiveItem(_ notification: NSNotification)
    {
        if let dict = notification.userInfo as NSDictionary?
        {
            if let listName = dict["ListName"] as? String, let itemName = dict["ItemName"] as? String {
                //find it's list and add it
                for list in lists
                {
                    if list.name == listName
                    {
                        list.items.append(Item(name: itemName, completed: false))
                        //write item in file
                        write()
                        myTableView.reloadData()
                    }
                }
            }
        }
    }
    
    //Modify status of item
    @objc func UpdateItem(_ notification: NSNotification)
    {
        if let dict = notification.userInfo as NSDictionary?
        {
            if let listName = dict["ListName"] as? String, let itemName = dict["ItemName"] as? String, let status = dict["ItemStatus"] as? String {
                //find it's list and add it
                for list in 0..<lists.count
                {
                    if lists[list].name == listName
                    {
                        for it in 0..<lists[list].items.count
                        {
                            if lists[list].items[it].name == itemName
                            {
                                
                                if(status == "0")
                                {
                                    lists[list].items[it].completed = false
                                }
                                else{
                                    lists[list].items[it].completed = true
                                }
                                //make change in file
                                write()
                                myTableView.reloadData()
                            }
                        }
                    }
                }
                // There's probably an easier way to do this search
            }
        }
    }
    
    //create new cell in table view
    func AddNewCell(newGroup : Group){
        print(newGroup.items)
        lists.append(newGroup)
        
        //update table view
        myTableView.beginUpdates()
        myTableView.insertRows(at: [IndexPath(row: lists.count - 1, section: 0)], with: .automatic)
        myTableView.endUpdates()
    }
    
    func AddNewCellToDisk(newGroup : Group){
        print(newGroup)
        lists.append(newGroup)
        write()
        //update table view
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
            var exists = false
            //check if a list with that name already exists
            for list in self.lists
            {
                if list.name == newTitle
                {
                    exists = true
                }
            }
            if !exists
            {
                self.AddNewCellToDisk(newGroup: Group(name: newTitle, items: []))
            }
            else
            {
                self.callErrorAlert()
            }
            
        }
        
        myAlert.addAction(okAction)
        myAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
    //create alert for error
    @IBAction func callErrorAlert() {
        let myAlert = UIAlertController(title: "Existing List", message: "A list with that name already exists.", preferredStyle: .alert)
                 
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        myAlert.addAction(okAction)
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
    
    //read data from disk
    func read()
    {
        if let file = getFile()
        {
            if let data = try? Data(contentsOf: file)
            {
                do
                {
                    let foundLists = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Group]
                    for list in foundLists!
                    {
                        self.AddNewCell(newGroup: Group(name: list.name!, items: list.items))
                    }
                } catch{
                    
                }
            }
        }
        
    }
    
    //write data from disk
    func write()
    {
        //let dataString = lists.joined(separator:"\n")
        if let file = getFile()
        {
            print(file)
            let archiver = try? NSKeyedArchiver.archivedData(withRootObject: lists, requiringSecureCoding: false)
            
            try? archiver?.write(to: file)
        }
    }
    
    //get file
    func getFile() -> URL?
    {
        let fileManager = FileManager.default
        
        do
        {
            let myDocument = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

            return myDocument.appendingPathComponent("TestDta.txt")
            
        } catch{
           return nil
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
            write()
        }
    }
    
    //show message to user when trying to delete a row
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete \(lists[indexPath.row])?"
    }
}
