//
//  DataClasses.swift
//  MyToDoList
//
//  Created by Ana Carolina Arellano Alvarez on 11/09/21.
//

import Foundation

class Group: NSObject, NSCoding {
    var items: [Item]
    var name: String?
    init(name: String, items: [Item]) {
        self.name = name
        self.items = items
    }
    func encode(with coder: NSCoder) {
        coder.encode(self.items, forKey: "items")
        coder.encode(self.name, forKey: "name")
    }
    
    required convenience init?(coder: NSCoder) {
        let name = coder.decodeObject(forKey: "name") as! String
        let items = coder.decodeObject(of: [NSArray.self, Item.self], forKey: "items") as! [Item]
        
        self.init(name: name, items: items)
    }
}

class Item: NSObject, NSCoding {
    var name: String?
    var completed: Bool =  false
    init(name: String, completed: Bool) {
        self.name = name
        self.completed = completed
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.completed, forKey: "completed")
    }
    
    required convenience init?(coder: NSCoder) {
        let name = coder.decodeObject(forKey: "name") as! String
//        let completed = coder.decodeObject(forKey: "completed") as! Bool
        
        self.init(name: name, completed: false)
    }
}
