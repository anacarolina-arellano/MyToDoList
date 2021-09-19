//
//  DataClasses.swift
//  MyToDoList
//
//  Created by Ana Carolina Arellano Alvarez on 11/09/21.
//

import Foundation

class Group {
    var items: [Item] = []
    var name: String?
}

class Item{
    var name: String?
    var completed: Bool =  false
}
