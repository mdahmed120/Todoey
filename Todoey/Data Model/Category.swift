//
//  Category.swift
//  Todoey
//
//  Created by Macbook Air on 9/17/19.
//  Copyright © 2019 Macbook Air. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object
{
    @objc dynamic var name : String = ""
    //describing the relationship b/w parent and child
    let items = List<Item>()
}
