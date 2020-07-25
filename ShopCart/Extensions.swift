//
//  Extensions.swift
//  ShopCart
//
//  Created by Saravanakumar on 24/07/20.
//  Copyright © 2020 Saravanakumar. All rights reserved.
//

import UIKit
import CoreData

let kFontAwesomeFamilyName = "FontAwesome"

extension UIColor {
    static let appColor = UIColor(red: 17/255, green: 30/255, blue: 45/255, alpha: 1.0)
}

extension UIViewController {
    
    class func initializeController<T>(withIdentifier identifier: String) -> T {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifier) as! T
    }
}

extension NSManagedObject {
    
    class func entity(withName entityName: String, context: NSManagedObjectContext) -> NSManagedObject? {
                      
           let request = NSFetchRequest<NSFetchRequestResult>()
           
           let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
           request.entity = entity
           request.fetchLimit = 1
           
           var results: [Any]? = nil
           var _: Error?
       
           results = try! context.fetch(request)
    
           if results == nil {
               print("DB_FETCH_ERROR")
           }
           if results != nil, results!.count > 0{
               return results![0] as? NSManagedObject
           }
           return nil
    }
    
    class func entites(witName entityName:String, sortDescriptor: NSSortDescriptor?, context: NSManagedObjectContext) -> [NSManagedObject]? {
                
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = [sortDescriptor!]
        }
        
        var results: [Any]?
        
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("Fetch error: \(error.localizedDescription)")
        }
        
        return results as? [NSManagedObject]
    }
    
    class func create<T>(withEntityName name:String,context: NSManagedObjectContext) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! T
    }
}

extension UIButton {
    
    func setIcon(_ iconType: String?, title: String?, fontSize size: CGFloat, textColor color: UIColor) {
        
        var _title = title
        
        if iconType != nil {
            
            if (_title != nil) && (_title!.count > 0) {
                _title = "\(iconType!)  \(_title!)"
            }
            else {
                _title = iconType!
            }
        }
        if ( _title != nil && _title!.count > 0) {
            
            let attributedText = NSAttributedString(string: _title!, attributes: [NSAttributedString.Key.font: UIFont(name: kFontAwesomeFamilyName, size:size)!, NSAttributedString.Key.foregroundColor: color])
            setAttributedTitle(attributedText, for: .normal) 
        }
        else {
            titleLabel?.font = UIFont(name: kFontAwesomeFamilyName, size: size)
            setTitleColor(color, for: .normal)
        }
    }
}

extension UIView {
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2.0
        layer.cornerRadius = 5.0
    }
}

extension String {
    func height(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}

extension UILabel {
    
    func setIcon(_ iconType: String?, title: String?, fontSize size: CGFloat, textColor color: UIColor) {
        var labelTitle = title
        
        if iconType != nil {
            if let ttl = title {
                labelTitle = ("\(iconType!) \(ttl)")
            }
            else {
                labelTitle = iconType!
            }
        }
        if (labelTitle != nil && labelTitle!.count > 0) {
            let attributedText = NSAttributedString(string: labelTitle!, attributes: [NSAttributedString.Key.font: UIFont(name: kFontAwesomeFamilyName, size: size)!, NSAttributedString.Key.foregroundColor: color])
            self.attributedText = attributedText
        }
        else {
            font = UIFont(name: kFontAwesomeFamilyName, size: size)
            textColor = color
        }
    }
}

extension UIBarButtonItem {
    class func barButtonItem(withIcon iconType: String , target: Any, action: Selector, size: CGFloat) -> UIBarButtonItem {
        
        let barButtonItem = UIBarButtonItem(title: iconType, style: .plain, target: target, action: action)
        
        barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: kFontAwesomeFamilyName, size: size)!, NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: kFontAwesomeFamilyName, size: size)!,NSAttributedString.Key.foregroundColor: UIColor.white], for: .highlighted)
        barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: kFontAwesomeFamilyName, size: size)!,NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        return barButtonItem
    }
}
