//
//  CategoriesV2ViewController.swift
//  Coco
//
//  Created by Erick Monfil on 19/02/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class CategoriesV2ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var imgBaner: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "CategoryV2CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        roundView.layer.cornerRadius = 30
        roundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        roundView.layer.shadowColor = UIColor.gray.cgColor
        roundView.layer.shadowOffset = CGSize(width: 0, height: -4)
        roundView.layer.shadowOpacity = 0.4
        roundView.layer.shadowRadius = 2
        
        imgBaner.layer.cornerRadius = self.imgBaner.layer.frame.width / 2
        
    }
    

    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}

extension CategoriesV2ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryV2CollectionViewCell
        cell.imgCategory.layer.cornerRadius = cell.imgCategory.layer.frame.width / 2
        cell.imgCategory.layer.masksToBounds = false
        cell.imgCategory.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
            
        return CGSize(width:widthPerItem, height:224)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
