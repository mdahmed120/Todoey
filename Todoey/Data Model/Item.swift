//
//  Item.swift
//  Todoey
//
//  Created by Macbook Air on 9/17/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object
{
   @objc dynamic var title : String = ""
   @objc dynamic var done : Bool = false
   @objc dynamic var dateCreated : Date?
    //items = name specified in Category(Parent Category)
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
