//
//  RestaurantListViewController.swift
//  ShopCart
//
//  Created by Saravanakumar on 25/07/20.
//  Copyright © 2020 Saravanakumar. All rights reserved.
//

import UIKit

class RestaurantListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var restaurants: [Restaurant]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Restaurants"
        self.loadData()
        self.statusbar()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func statusbar() {
        
        let tag = 38482

        let window = UIApplication.shared.windows.first

        if let statusBar = window?.viewWithTag(tag) {
            statusBar.removeFromSuperview()
        }
         
        guard let statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame else { return }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.tag = tag
        statusBarView.backgroundColor = UIColor.appColor
        window?.addSubview(statusBarView)
    }

    fileprivate func loadData() {
        
        restaurants = Restaurant.entites(witName: "Restaurant", sortDescriptor: NSSortDescriptor(key: "id", ascending: true),context: AppDelegate.shared.managedObjectContext) as? [Restaurant]
                        
        if restaurants == nil || !(restaurants!.count > 0) {
            if let path = Bundle.main.path(forResource: "restaurant", ofType: "json") {
                do  {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)

                    if let result = json as? [[String:Any]], result.count > 0 {
                        self.insertJson(withData: result)
                    }
                } catch let error {
                    print("Error: \(error)")
                }
            }
        } else {
            tableView.reloadData()
        }
    }
    
    fileprivate func insertJson(withData json:[[String:Any]]) {
        
        let context = AppDelegate.shared.managedObjectContext

        for restaurantJson in json {
            
            let restaurant: Restaurant = Restaurant.create(withEntityName: "Restaurant", context: context)
            restaurant.id = restaurantJson["id"] as! Int64
            restaurant.name = restaurantJson["name"] as? String
            restaurant.availableDays = restaurantJson["availableDays"] as? String
            restaurant.image = restaurantJson["image"] as? String
            restaurant.openTime = restaurantJson["openTime"] as? String
            restaurant.ratings = restaurantJson["ratings"] as! Float
            restaurant.phoneNumber = restaurantJson["phoneNumber"] as! Int64
            restaurant.reviews = restaurantJson["reviews"] as! Int64
 
            if let menus = restaurantJson["menus"] as? [[String:Any]] {
                
                for menuJson in menus {
                    
                    let menu: Menu = Menu.create(withEntityName: "Menu", context: context)
                    menu.id = menuJson["id"] as! Int64
                    menu.name = menuJson["name"] as? String
                    menu.restaurant = restaurant
                    
                    if let menuItems = menuJson["menuItems"] as? [[String:Any]] {
                        
                        for menuItemJson in menuItems {
                            let menuItem: MenuItem = MenuItem.create(withEntityName: "MenuItem", context: context)
                            menuItem.id = menuItemJson["id"] as! Int64
                            menuItem.name = menuItemJson["name"] as? String
                            menuItem.desc = menuItemJson["desc"] as? String
                            menuItem.price = menuItemJson["price"] as! Int64
                            menuItem.menu = menu
                        }
                    }
                }
            }
            restaurants?.append(restaurant)
        }
                     
        context.performAndWait {
            AppDelegate.shared.saveContext()
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (restaurants != nil && restaurants!.count > 0) ? restaurants!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
            cell!.textLabel?.textColor = UIColor.black
            cell!.backgroundColor = UIColor.clear
            cell!.selectionStyle = .none
            cell!.textLabel?.font = UIFont.systemFont(ofSize: 19.0)
            cell!.accessoryType = .disclosureIndicator
        }
        
        let restaurant = restaurants![indexPath.row]
        
        cell!.textLabel?.text = restaurant.name
        
        return cell!
    }

    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = restaurants![indexPath.row]
        
        let restaurantDetailView: RestaurantDetailViewController = RestaurantDetailViewController.initializeController(withIdentifier: "restaurantDetailView")
        restaurantDetailView.restaurant = restaurant
        self.navigationController?.pushViewController(restaurantDetailView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
