//
//  Items_VC.swift
//  MyToDoList
//
//  Created by Ana Carolina Arellano Alvarez on 16/09/21.
//

import UIKit

class Items_VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

extension Items_VC: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyItemsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myItemCell", for: indexPath) as! MyItemsTableViewCell
        
        //cell.title.text = "Name of List"
        cell.title.text = "Item"
        return cell
    }
}
