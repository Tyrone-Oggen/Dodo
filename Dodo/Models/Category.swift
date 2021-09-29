//
//  Category.swift
//  Dodo
//
//  Created by Tyrone Oggen on 2021/09/26.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    //Defines the forward relationship to the items
    let items = List<Item>()
}
