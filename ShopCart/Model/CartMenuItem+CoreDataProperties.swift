//
//  CartMenuItem+CoreDataProperties.swift
//  ShopCart
//
//  Created by Saravanakumar on 25/07/20.
//  Copyright © 2020 Saravanakumar. All rights reserved.
//
//

import Foundation
import CoreData


extension CartMenuItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartMenuItem> {
        return NSFetchRequest<CartMenuItem>(entityName: "CartMenuItem")
    }

    @NSManaged public var comments: String?
    @NSManaged public var quantity: Int64
    @NSManaged public var menuItem: MenuItem?
    @NSManaged public var cart: Cart?

}
