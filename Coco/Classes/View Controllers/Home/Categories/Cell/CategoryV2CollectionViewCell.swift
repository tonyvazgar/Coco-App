//
//  CategoryV2CollectionViewCell.swift
//  Coco
//
//  Created by Erick Monfil on 19/02/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class CategoryV2CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vistaSombra: UIView!
    
    @IBOutlet weak var ancho: NSLayoutConstraint!
    @IBOutlet weak var alto: NSLayoutConstraint!
    @IBOutlet weak var viewImage: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //imgCategory.layer.cornerRadius = 63
        //viewImage.layer.cornerRadius = 63
        
        //imgCategory.layer.cornerRadius = self.imgCategory.layer.frame.width / 2
        
        //imgCategory.layer.masksToBounds = false
        //imgCategory.clipsToBounds = true
        
        vistaSombra.backgroundColor = .white
        vistaSombra.layer.cornerRadius = 30
        
        let gris = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.1)
        vistaSombra.layer.shadowColor = gris.cgColor
        vistaSombra.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaSombra.layer.shadowOpacity = 0.9
        vistaSombra.layer.shadowRadius = 18
        
        
        viewImage.layer.shadowColor = UIColor.gray.cgColor
        viewImage.layer.shadowOffset = CGSize(width: 0, height: 6)
        viewImage.layer.shadowOpacity = 0.4
        viewImage.layer.shadowRadius = 6
        
        print("ancho : \(self.frame.size.width)")
        print("alto : \(self.frame.size.height)")
        
        
        alto.constant = self.frame.size.width - 65
        ancho.constant = self.frame.size.width - 65
        viewImage.layer.cornerRadius = (self.frame.size.width - 65) / 2
        imgCategory.layer.cornerRadius = (self.frame.size.width - 65) / 2
        imgCategory.clipsToBounds = true
    }

}
