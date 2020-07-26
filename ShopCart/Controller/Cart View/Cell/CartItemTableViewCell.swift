//
//  CartItemTableViewCell.swift
//  ShopCart
//
//  Created by Saravanakumar on 23/07/20.
//  Copyright © 2020 Saravanakumar. All rights reserved.
//

import UIKit

class CartItemTableViewCell: RestaurantTableViewCell {

    @IBOutlet weak var addMessageButton: UIButton!
    @IBOutlet weak var addComment: UIButton!
    
    fileprivate var cartMenuItem: CartMenuItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(withCartMenuItem cartMenuItem: CartMenuItem) {

        self.cartMenuItem = cartMenuItem
        
        addComment.setIcon("\u{f0e6}", title: nil, fontSize: 28, textColor: .black)
        plusButton.addTarget(self, action: #selector(addItem(sender:)), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusItem(sender:)), for: .touchUpInside)

        itemName.text = cartMenuItem.menuItem!.name
        
        price.text = "$ \(cartMenuItem.menuItem!.price)"
        
        count.text = "\(cartMenuItem.quantity)"
        
        self.updateDescLabel(withDesc: cartMenuItem.menuItem!.desc)

        self.layoutIfNeeded()
        
    }
    
    @objc override func addItem(sender: UIButton) {
        
        guard cartMenuItem.quantity < 20 else {
            return
        }
        
        let context = AppDelegate.shared.managedObjectContext
        
        cartMenuItem.quantity += 1
        
        count.text = "\(cartMenuItem.quantity)"
        
        context.performAndWait {
            AppDelegate.shared.saveContext()
        }
        
        delegate.updateCartView()
    }
    
    @objc override func minusItem(sender: UIButton) {
        
        let context = AppDelegate.shared.managedObjectContext

        count.text = "\(cartMenuItem.quantity)"
        
        if cartMenuItem.quantity > 1 {
            cartMenuItem.quantity -= 1
        } else {
            context.delete(cartMenuItem)
        }
                    
        context.performAndWait {
            AppDelegate.shared.saveContext()
        }
        
        delegate.updateCartView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
