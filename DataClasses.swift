//
//  DataClasses.swift
//  MyToDoList
//
//  Created by Ana Carolina Arellano Alvarez on 11/09/21.
//

import Foundation

class Group {
    var items: Array<Item> = Array()
    var name: String?
    init(name: String, items: Array<Item>) {
        self.name = name
        self.items = items
    }
}

class Item{
    var name: String?
    var completed: Bool =  false
    init(name: String) {
        self.name = name
    }
}
