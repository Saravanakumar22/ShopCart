//
//  MenuItem+CoreDataProperties.swift
//  ShopCart
//
//  Created by Saravanakumar on 25/07/20.
//  Copyright © 2020 Saravanakumar. All rights reserved.
//
//

import Foundation
import CoreData


extension MenuItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuItem> {
        return NSFetchRequest<MenuItem>(entityName: "MenuItem")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var price: Int64
    @NSManaged public var menu: Menu?
    @NSManaged public var cartMenuItem: CartMenuItem?

}
