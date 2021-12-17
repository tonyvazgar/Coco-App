//
//  ProductTableViewCell.swift
//  Coco
//
//  Created by Carlos Banos on 10/9/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

protocol ProductCellDelegate: AnyObject {
    func didAddProduct(index: Int)
}

final class ProductTableViewCell: UITableViewCell {

    @IBOutlet var backView: UIView!
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productDescriptionLabel: UILabel!
    @IBOutlet var productPriceLabel: UILabel!
    @IBOutlet var addToCartButton: UIButton!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var imageWidth: NSLayoutConstraint!
    @IBOutlet var imageHeight: NSLayoutConstraint!
    
    static let cellIdentifier = "ProductTableViewCell"
    
    var index: Int = 0
    weak var delegate: ProductCellDelegate?
    
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
        
        addToCartButton.roundCorners(8)
        addToCartButton.addBorder(thickness: 1, color: .cocoOrange)
        
        quantityLabel.roundCorners(quantityLabel.frame.height/2)
        quantityLabel.isHidden = true
        
        productImageView.roundCorners(8)
    }
    
    @IBAction private func addToCartButtonAction(_ sender: Any) {
        delegate?.didAddProduct(index: index)
    }
}
