//
//  Item.swift
//  Dodo
//
//  Created by Tyrone Oggen on 2021/09/26.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
