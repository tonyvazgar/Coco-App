//
//  giftsTableViewCell.swift
//  Coco
//
//  Created by Brandon Gonzalez on 16/06/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

protocol showMeTheGiftDetail {
    func showTheDetail(idNumber:String, orderStatus:String)
}

class giftsTableViewCell: UITableViewCell {
    
    var giftStatus : String?

    static let cellIdentifier = "giftsTableViewCell"
    
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var dateOrder: UILabel!
    @IBOutlet weak var statusOrder: UILabel!
    @IBOutlet weak var storeOrder: UILabel!
    @IBOutlet weak var friendOrder: UILabel!
    @IBOutlet weak var behindView: UIView!
    @IBOutlet weak var underGiftButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var delegate : showMeTheGiftDetail!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        orderName.roundCorners(12)
        behindView.layer.cornerRadius = 12
        underGiftButton.roundCorners(12)
        behindView.layer.masksToBounds = false
        behindView.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)
        behindView.layer.shadowRadius = 5
        behindView.layer.shadowOpacity = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func openTheGift(_ sender: UIButton) {
        let currentcellnumber = "\(sender.tag)"
        self.delegate.showTheDetail(idNumber: currentcellnumber, orderStatus: giftStatus!)
    }
    
    @IBAction func theDetails(_ sender: UIButton) {
        let currentcellnumber = "\(sender.tag)"
        self.delegate.showTheDetail(idNumber: currentcellnumber, orderStatus: giftStatus!)
    }
    
}
