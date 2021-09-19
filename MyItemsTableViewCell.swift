//
//  MyItemsTableViewCell.swift
//  MyToDoList
//
//  Created by Ana Carolina Arellano Alvarez on 18/09/21.
//

import UIKit

class MyItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var completed: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
