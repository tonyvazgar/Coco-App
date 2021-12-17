//
//  LocationHeaderView.swift
//  Coco
//
//  Created by Carlos Banos on 10/11/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class LocationHeaderView: UIView {
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    
    static func instantiate() -> Self {
        Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as! Self
    }
    
    var location: LocationsDataModel? {
        didSet {
            populateView()
        }
    }
    
    private func populateView() {
        nameLabel.text = location?.name
        locationLabel.text = location?.address
        ratingLabel.text = location?.rating
        
        if let image = location?.imgURL {
            iconImageView.kf.setImage(with: URL(string: image),
                                      placeholder: nil,
                                      options: [.transition(.fade(0.4))],
                                      progressBlock: nil,
                                      completionHandler: nil)
        }
    }
}
