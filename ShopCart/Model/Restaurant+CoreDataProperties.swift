//
//  Restaurant+CoreDataProperties.swift
//  ShopCart
//
//  Created by Saravanakumar on 25/07/20.
//  Copyright © 2020 Saravanakumar. All rights reserved.
//
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var image: String?
    @NSManaged public var ratings: Float
    @NSManaged public var availableDays: String?
    @NSManaged public var phoneNumber: Int64
    @NSManaged public var openTime: String?
    @NSManaged public var menus: NSSet?
    @NSManaged public var cart: Cart?
    @NSManaged public var reviews: Int64
}

// MARK: Generated accessors for menus
extension Restaurant {

    @objc(addMenusObject:)
    @NSManaged public func addToMenus(_ value: Menu)

    @objc(removeMenusObject:)
    @NSManaged public func removeFromMenus(_ value: Menu)

    @objc(addMenus:)
    @NSManaged public func addToMenus(_ values: NSSet)

    @objc(removeMenus:)
    @NSManaged public func removeFromMenus(_ values: NSSet)

}
