//
//  CartViewController.swift
//  ShopCart
//
//  Created by Saravanakumar on 23/07/20.
//  Copyright © 2020 Saravanakumar. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UpdateCartDelegate, DeliveryCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalCost: UILabel!
    
    fileprivate var isShowMore: Bool = false
    
    var cart: Cart!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    fileprivate func setupUI() {
        
        self.title = "My cart"

        self.navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItem(withIcon: "\u{f053}", target: self, action: #selector(backPressed), size: 22)
                
        updateTotalCost()
    }
    
    fileprivate func updateTotalCost() {
        if let cartSets = cart.cartMenuItems, let cartMenuItems = cartSets.allObjects as? [CartMenuItem], cartMenuItems.count > 0 {
            
            var price: Int64 = 0
            
            cartMenuItems.forEach { (cartMenuItem) in
                price += cartMenuItem.quantity * cartMenuItem.menuItem!.price
            }
            
            totalCost.text = "$ \(price)"
            
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        } else {
            
            let context = AppDelegate.shared.managedObjectContext
            
            context.delete(cart)
            
            AppDelegate.shared.saveContext()
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc fileprivate func backPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func showMoreTapped() {
        isShowMore = !isShowMore
        tableView.reloadData()
    }
    
    //MARK:- UpdateCartDelegate
    func didUpdateSelectIem() {
        self.updateTotalCost()
    }
    
    //MARK:- DeliveryCellDelegate
    func didSelectDeliveryOption(option: String) {
        cart.deliveryOption = option
    }
    
    //MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return isShowMore ? cart.cartMenuItems!.allObjects.count : cart.cartMenuItems!.allObjects.count > 2 ? 2 : cart.cartMenuItems!.allObjects.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cartMenuItems = cart.cartMenuItems!.allObjects as! [CartMenuItem]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell") as! CartItemTableViewCell
            cell.delegate = self
            cell.setupCell(withCartMenuItem: cartMenuItems[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryCell") as! DeliveryTableViewCell
            cell.delegate = self
            cell.setupDeliveryItem(withOption: cart.deliveryOption!)
            return cell
        }
    }
    
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (cart.cartMenuItems!.allObjects.count > 2 && !isShowMore) ? section == 0 ? 40 : 0 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        headerView.backgroundColor = .white
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: headerView.frame.width-15, height: headerView.frame.height))
        label.text = section == 0 ? "Review Orders" : "Delivery options"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        headerView.addSubview(label)
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 && cart.cartMenuItems!.allObjects.count > 2 && !isShowMore {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
            footerView.backgroundColor = .white
                        
            let button = UIButton(type: .roundedRect)
            button.frame = CGRect(x: tableView.frame.width-120, y: 0, width: 120, height: footerView.frame.height)
            let attributedText = NSAttributedString(string: "Show more", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
            button.setAttributedTitle(attributedText, for: .normal)
            button.addTarget(self, action: #selector(showMoreTapped), for: .touchUpInside)
            footerView.addSubview(button)
            
            return footerView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 80.0
        }
        
        var height: CGFloat = 85.0
        
        let cartMenuItems = cart.cartMenuItems!.allObjects as! [CartMenuItem]

        let cartMenuItem = cartMenuItems[indexPath.row]
        
        if let desc =  cartMenuItem.menuItem!.desc, desc.isEmpty == false {
            
            height += desc.height(tableView.frame.width-150, font: UIFont.systemFont(ofSize: 15.0))
        }
        
        return height
    }
}


