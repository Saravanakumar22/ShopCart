//
//  Menu+CoreDataProperties.swift
//  ShopCart
//
//  Created by Saravanakumar on 25/07/20.
//  Copyright © 2020 Saravanakumar. All rights reserved.
//
//

import Foundation
import CoreData


extension Menu {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Menu> {
        return NSFetchRequest<Menu>(entityName: "Menu")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var restaurant: Restaurant?
    @NSManaged public var menuItems: NSSet?

}

// MARK: Generated accessors for menuItems
extension Menu {

    @objc(addMenuItemsObject:)
    @NSManaged public func addToMenuItems(_ value: MenuItem)

    @objc(removeMenuItemsObject:)
    @NSManaged public func removeFromMenuItems(_ value: MenuItem)

    @objc(addMenuItems:)
    @NSManaged public func addToMenuItems(_ values: NSSet)

    @objc(removeMenuItems:)
    @NSManaged public func removeFromMenuItems(_ values: NSSet)

}
