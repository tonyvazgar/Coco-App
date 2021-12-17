//
//  MyPaymentsTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 10/18/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

protocol MyPaymentsCellDelegate: AnyObject {
    func didPressActionButton(_: Int)
    func didPressRemoveButton(_: Int)
}

final class MyPaymentsTableViewCell: UITableViewCell {
    @IBOutlet var backView: UIView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    static let cellIdentifier = "MyPaymentsTableViewCell"
    
    weak var delegate: MyPaymentsCellDelegate?
    var index: Int = 0
    
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
        
        actionButton.roundCorners(actionButton.frame.height/2)
    }
    
    @IBAction
    private func actionButtonTap(_ sender: Any) {
        delegate?.didPressActionButton(index)
    }
    
    @IBAction
    private func deleteButtonAction(_ sender: Any) {
        delegate?.didPressRemoveButton(index)
    }
}
