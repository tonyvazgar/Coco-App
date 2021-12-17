//
//  MyCocoCardsTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 2/19/21.
//  Copyright © 2021 Easycode. All rights reserved.
//

import UIKit

class MyCocoCardsTableViewCell: UITableViewCell {
    @IBOutlet var codeLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet private var backView: UIView!
    @IBOutlet private var dateView: UIView!
    
    static let cellIdentifier = "MyCocoCardsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // corner radius
        backView.layer.cornerRadius = 8

        // border
        backView.layer.borderWidth = 0.5
        backView.layer.borderColor = UIColor.lightGray.cgColor

        // shadow
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = .zero
        backView.layer.shadowOpacity = 0.25
        backView.layer.shadowRadius = 2
        
        dateView.roundCorners(dateView.frame.height/2)
    }
}
