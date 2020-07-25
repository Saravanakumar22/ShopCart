//
//  Cart+CoreDataProperties.swift
//  ShopCart
//
//  Created by Saravanakumar on 25/07/20.
//  Copyright © 2020 Saravanakumar. All rights reserved.
//
//

import Foundation
import CoreData


extension Cart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: "Cart")
    }

    @NSManaged public var id: Int64
    @NSManaged public var deliveryOption: String?
    @NSManaged public var cartMenuItems: NSSet?
    @NSManaged public var restaurant: Restaurant?

}

// MARK: Generated accessors for cartMenuItems
extension Cart {

    @objc(addCartMenuItemsObject:)
    @NSManaged public func addToCartMenuItems(_ value: CartMenuItem)

    @objc(removeCartMenuItemsObject:)
    @NSManaged public func removeFromCartMenuItems(_ value: CartMenuItem)

    @objc(addCartMenuItems:)
    @NSManaged public func addToCartMenuItems(_ values: NSSet)

    @objc(removeCartMenuItems:)
    @NSManaged public func removeFromCartMenuItems(_ values: NSSet)

}
