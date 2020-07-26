//
//  RestaurantTableViewCell.swift
//  ShopCart
//
//  Created by Saravanakumar on 22/07/20.
//  Copyright © 2020 Saravanakumar. All rights reserved.
//

import UIKit
import CoreData

protocol UpdateCartDelegate {
    func didUpdateSelectIem()
}

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var itemDescHeight: NSLayoutConstraint!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var addItemView: UIView!
    @IBOutlet weak var count:UILabel!
    
    var delegate: UpdateCartDelegate!
    
    fileprivate var menuItem: MenuItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addItemView.layer.borderColor = UIColor.orange.cgColor
        addItemView.layer.borderWidth = 1.0
    }
    
    func setupCell(withMenuItem menuItem: MenuItem) {
        
        self.menuItem = menuItem

        plusButton.addTarget(self, action: #selector(addItem(sender:)), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addItem(sender:)), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusItem(sender:)), for: .touchUpInside)

        itemName.text = menuItem.name
        price.text = "$ \(menuItem.price)"
               
        self.updateDescLabel(withDesc: menuItem.desc)
                
        self.updateAddItem()
        
        self.layoutIfNeeded()
    }
    
    fileprivate func updateAddItem() {

        if(menuItem.cartMenuItem == nil ) {
            addItemView.isHidden = true
            addButton.isHidden = false
        
        } else {
            addItemView.isHidden = false
            addButton.isHidden = true
            count.text = "\(menuItem.cartMenuItem!.quantity)"
        }
        
        delegate.didUpdateSelectIem()
    }
    
    func updateDescLabel(withDesc desc:String?) {
        
        if desc != nil && desc!.isEmpty == false {
            itemDesc.isHidden = false

            itemDesc.text = desc

            let height = desc!.height(self.frame.width-150, font: UIFont.systemFont(ofSize: 15.0)) + 5 //Extra 5 for spacing
            
            itemDescHeight.constant = height
        } else {
            itemDesc.isHidden = true
            
            itemDescHeight.constant = 0
        }
    }
    
    @objc func addItem(sender: UIButton) {
        
        checkCartRestaurant()
    }
    
    fileprivate func addToCart() {
        
        let context = AppDelegate.shared.managedObjectContext
        
        if let cartMenuitem =  self.menuItem.cartMenuItem{
        
            guard cartMenuitem.quantity < 20 else {
                return
            }
            
            cartMenuitem.quantity += 1
        
        } else {
            let cart = Cart.entity(withName: "Cart", context: context) as? Cart
            
            if cart == nil {
                
                let cartItem: Cart = Cart.create(withEntityName: "Cart", context: context)
                cartItem.deliveryOption = "Dine-In"
                cartItem.restaurant = menuItem.menu!.restaurant
            
                createCartmenuItem(withCart: cartItem, quantity: 1, context:context )
            } else {
                createCartmenuItem(withCart: cart!, quantity: 1, context: context)
            }
        }
        
        context.performAndWait {
            AppDelegate.shared.saveContext()
        }
        
        self.updateAddItem()
    }
    
    fileprivate func createCartmenuItem(withCart cart:Cart, quantity:Int64, context: NSManagedObjectContext) {
        let cartMenuItem: CartMenuItem = CartMenuItem.create(withEntityName: "CartMenuItem", context: context)
        cartMenuItem.quantity = quantity
        cartMenuItem.menuItem = menuItem
        cartMenuItem.cart = cart
    }
    
    @objc func minusItem(sender: UIButton) {
        
        if let cartMenuitem =  self.menuItem.cartMenuItem{

            let context = AppDelegate.shared.managedObjectContext

            if cartMenuitem.quantity > 1 {
                cartMenuitem.quantity -= 1
            } else {
                context.delete(cartMenuitem)
            }
                        
            context.performAndWait {
                AppDelegate.shared.saveContext()
            }
            
            self.updateAddItem()
        }
    }

    fileprivate func checkCartRestaurant() {
        
        let context = AppDelegate.shared.managedObjectContext
        
        if let cart = Cart.entity(withName: "Cart", context: context) as? Cart {
            
            if cart.restaurant != menuItem.menu!.restaurant {
                
                let alertController = UIAlertController(title: "View Cart", message: "Would you like to clear the previous items", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alertController.addAction(UIAlertAction(title: "Clear items", style: .destructive, handler: { (_) in
                    
                    context.delete(cart)
                    AppDelegate.shared.saveContext()
                    
                    self.addToCart()
                }))
                
                guard let window = UIApplication.shared.windows.first else {
                    return
                }
                
                window.rootViewController!.present(alertController, animated: true, completion: nil)
            } else {
                self.addToCart()
            }
        } else {
            self.addToCart()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
