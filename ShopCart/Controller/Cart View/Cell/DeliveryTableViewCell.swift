//
//  DeliveryTableViewCell.swift
//  ShopCart
//
//  Created by Saravanakumar on 23/07/20.
//  Copyright © 2020 Saravanakumar. All rights reserved.
//

import UIKit

protocol DeliveryCellDelegate {
    func updateDeliveryOption(option:String)
}

class DeliveryTableViewCell: UITableViewCell {

    @IBOutlet weak var dineIn: UILabel!
    @IBOutlet weak var takeAway: UILabel!
    
    @IBOutlet weak var dineInIcon: UILabel!
    @IBOutlet weak var takeAwayIcon: UILabel!

    @IBOutlet weak var dineInView: UIView!
    @IBOutlet weak var takeawayView: UIView!
    
    var delegate: DeliveryCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupDeliveryItem(withOption option:String) {
                
        dineIn.setIcon("\u{f0f5}", title: " Dine-In", fontSize: 19, textColor: .black)
        takeAway.setIcon("\u{f0d1}", title: " Take way", fontSize: 19, textColor: .black)
        
        self.updateDeliveryOption(isDineIn: option == "Dine-In" ? true : false)
        
        let dineInTap = UITapGestureRecognizer(target: self, action: #selector(dineInGesture(gesture:)))
        dineInTap.numberOfTapsRequired = 1
        dineInView.addGestureRecognizer(dineInTap)
        
        let takeawayTap = UITapGestureRecognizer(target: self, action: #selector(takewayGesture(gesture:)))
        takeawayTap.numberOfTapsRequired = 1
        takeawayView.addGestureRecognizer(takeawayTap)
    }
    
    func updateDeliveryOption(isDineIn:Bool) {
                
        if isDineIn {
            dineInIcon.setIcon("\u{f192}", title: nil, fontSize: 19, textColor: .orange)
            takeAwayIcon.setIcon("\u{f10c}", title: nil, fontSize: 19, textColor: .gray)
        } else {
            dineInIcon.setIcon("\u{f10c}", title: nil, fontSize: 19, textColor: .gray)
            takeAwayIcon.setIcon("\u{f192}", title: nil, fontSize: 19, textColor: .orange)
        }
        
    }
    
    @objc func dineInGesture(gesture: UITapGestureRecognizer) {
        self.updateDeliveryOption(isDineIn: true)
        
        delegate.updateDeliveryOption(option: "Dine-In")
    }
    
    @objc func takewayGesture(gesture: UITapGestureRecognizer) {
        self.updateDeliveryOption(isDineIn: false)
        
        delegate.updateDeliveryOption(option: "Take way")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
