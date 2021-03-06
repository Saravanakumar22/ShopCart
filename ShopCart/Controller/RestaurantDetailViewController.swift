//
//  ViewController.swift
//  ShopCart
//
//  Created by Saravanakumar on 22/07/20.
//  Copyright © 2020 Saravanakumar. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UpdateCartDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restaurantView: UIView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var reviewAndTime: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var viewCartButton: UIButton!
    @IBOutlet weak var reviewAndTimeHeight: NSLayoutConstraint!
    @IBOutlet weak var restaurantViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewCartHeight: NSLayoutConstraint!
    @IBOutlet weak var headerImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var customHeaderView: UIView!
    @IBOutlet weak var restaurantNameHeight: NSLayoutConstraint!
    
    var restaurant: Restaurant!
    var menus: [Menu]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.updateRestaurantDetail()
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    fileprivate func setupUI() {
                
        menus = restaurant.menus?.allObjects as? [Menu]
        menus = menus.sorted(by: {$0.id < $1.id })
                
        restaurantView.addShadow()
        
        navBar.backgroundColor = .clear
        menuButton.setIcon("\u{f0f5}", title: "Menu", fontSize: 19, textColor: .appColor)
        backButton.setIcon("\u{f053}", title: nil, fontSize: 22, textColor: .white)
        shareButton.setIcon("\u{f045}", title: nil, fontSize: 24, textColor: .white)
        infoButton.setIcon("\u{f05a}", title: nil, fontSize: 24, textColor: .white)
        viewCartButton.setIcon("\u{f07a}", title: "VIEW CART", fontSize: 19, textColor: .white)
    }
    
    fileprivate func updateRestaurantDetail() {
        
        let reviewsCount: String

        if restaurant.reviews > 100 {
            
            let count = Int(floor(Double(restaurant.reviews) / 100) * 100)
            reviewsCount = count == restaurant.reviews ? String(restaurant.reviews) : "\(count)+"
        } else {
            reviewsCount = String(restaurant.reviews)
        }
        
        let textMaxWidth = UIScreen.main.bounds.width - 75
        
        var restaurantDetailHeight: CGFloat = 135.0
        
        //Restaurant name
        restaurantName.text = restaurant.name
        restaurantNameHeight.constant = restaurant.name!.height(textMaxWidth, font: UIFont.boldSystemFont(ofSize: 22)) + 5
        restaurantDetailHeight += restaurantNameHeight.constant
        
        phoneNumber.setIcon("\u{f095}", title: "Reach us at : \(restaurant.phoneNumber)", fontSize: 18, textColor: .black)
        
        //Restaurant opening time
        let reviewString = "\(restaurant.ratings) (\(reviewsCount)) | \(restaurant.availableDays!) : \(restaurant.openTime!)"
        reviewAndTime.setIcon("\u{f006}", title: reviewString, fontSize: 18, textColor: .black)
        let height = reviewString.height(textMaxWidth, font: UIFont.systemFont(ofSize: 18.0))
        reviewAndTimeHeight.constant = height + 10 //Extra 10 for spacing
        restaurantViewHeight.constant = restaurantDetailHeight + height
        var headerViewHeight = restaurantViewHeight.constant
            
        //Header Image
        if let imageString = restaurant.image, let image = UIImage(named: imageString) {
            headerImageView.image = image
            headerImageViewHeight.constant = (image.size.height / (image.size.width/UIScreen.main.bounds.width))
            headerViewHeight += headerImageViewHeight.constant - 30
        } else {
            headerImageView.isHidden = true
            headerImageViewHeight.constant = 45.0
            headerViewHeight += 10
        }
        
        customHeaderView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            customHeaderView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
            customHeaderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            customHeaderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            customHeaderView.heightAnchor.constraint(equalToConstant: headerViewHeight)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    fileprivate func updateViewCartButton() {
                
        if let cart = restaurant.cart, let cartSets = cart.cartMenuItems, let cartMenuItems = cartSets.allObjects as? [CartMenuItem] ,cartMenuItems.count > 0 {
         
            let quantities = cartMenuItems.map { $0.quantity }
            
            let reducedNumberSum = quantities.reduce(0,+)
            
            let itemsCountString = reducedNumberSum > 1 ? "\(reducedNumberSum) items" : "\(reducedNumberSum) item"
            
            viewCartButton.setIcon("\u{f07a}", title: "VIEW CART (\(itemsCountString))", fontSize: 19, textColor: .white)
            
            if viewCartButton.isHidden {
                viewCartButton.isHidden = false
                viewCartHeight.constant = 50

                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            
            if !viewCartButton.isHidden {
                viewCartButton.isHidden = true
                viewCartHeight.constant = 0
                
                if let cart = restaurant.cart {
                    let context = AppDelegate.shared.managedObjectContext
                    context.delete(cart)
                    context.performAndWait {
                        AppDelegate.shared.saveContext()
                    }
                }

                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @IBAction fileprivate func backPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction fileprivate func bookTableTapped() {
        
    }
    
    @IBAction fileprivate func viewCartTapped() {
        let cartView: CartViewController = CartViewController.initializeController(withIdentifier: "cartView")
        cartView.cart = restaurant.cart!
        self.navigationController?.pushViewController(cartView, animated: true)
    }
    
    //MARK:- UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > 130 && tableView.contentSize.height > self.view.frame.height {
            navBar.backgroundColor = UIColor.appColor
        } else {
            navBar.backgroundColor = .clear
        }
    }
    
    //MARK:- UpdateCartDelegate
    func didUpdateSelectIem() {
        self.updateViewCartButton()
    }
    
    //MARK:- UITableviewCellDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let menu = menus[section]
        return menu.menuItems!.allObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantItemCell") as! RestaurantTableViewCell
        
        let menuItem = (menus[indexPath.section].menuItems!.allObjects as! [MenuItem]).sorted(by: {$0.id < $1.id })
        cell.delegate = self
        cell.setupCell(withMenuItem: menuItem[indexPath.row])
        
        return cell
    }
    
    //MARK:- UITableviewCellDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        headerView.backgroundColor = .white
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: headerView.frame.width-15, height: headerView.frame.height))
        label.text = "Starter"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        headerView.addSubview(label)
        return headerView
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let menuItems = (menus[indexPath.section].menuItems!.allObjects as! [MenuItem]).sorted(by: {$0.id < $1.id })
        let menuItem = menuItems[indexPath.row]
        
        var height: CGFloat = 90.0
    
        if menuItem.desc != nil && menuItem.desc!.isEmpty == false {
            height += menuItem.desc!.height(tableView.frame.width-150, font: UIFont.systemFont(ofSize: 15.0))
        }
        
        return height
    }
}
