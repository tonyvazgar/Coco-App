//
//  ProductCartTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 10/19/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

protocol ProductCartCellDelegate: AnyObject {
    func didTapDelete(index: Int)
    func didDecreaseQuantity(index: Int)
    func didIncreaseQuantity(index: Int)
}

final class ProductCartTableViewCell: UITableViewCell {
    @IBOutlet var productName: UILabel!
    @IBOutlet var quantity: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var stepperContainerView: UIView!
    @IBOutlet var productImageView: UIImageView!
    
    @IBOutlet var imageWidth: NSLayoutConstraint!
    @IBOutlet var imageHeight: NSLayoutConstraint!
    
    var index: Int = 0
    weak var delegate: ProductCartCellDelegate?
    
    static let cellIdentifier = "ProductCartTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.roundCorners(8)
        stepperContainerView.roundCorners(8)
        stepperContainerView.addBorder(thickness: 1, color: .cocoOrange)
    }
    
    @IBAction private func deleteAction(_ sender: Any) {
        delegate?.didTapDelete(index: index)
    }
    
    
    @IBAction private func addButtonAction(_ sender: Any) {
        delegate?.didIncreaseQuantity(index: index)
    }
    
    @IBAction private func lessButtonAction(_ sender: Any) {
        delegate?.didDecreaseQuantity(index: index)
    }
}
