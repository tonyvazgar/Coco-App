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
    @IBOutlet weak var lblCategoryName: UILabel!
    
    
    @IBOutlet weak var imgCanasta: UIImageView!
    @IBOutlet weak var vistaLogo: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var vistaCanasta: UIView!
    @IBOutlet weak var btnCanasta: UIButton!
    @IBOutlet weak var lblProductosCanasta: UILabel!
    private(set) var categories: [Category] = []
    private var loader = LoaderVC()
    var businessId: String?
    var locationId: String?
    var location: LocationsDataModel?
    
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
        
        vistaCanasta.layer.cornerRadius = 15
        btnCanasta.layer.cornerRadius = 15
        btnCanasta.clipsToBounds = true
        
        
        vistaCanasta.layer.shadowColor = UIColor.gray.cgColor
        vistaCanasta.layer.shadowOffset = CGSize(width: 0, height: 3)
        vistaCanasta.layer.shadowOpacity = 0.4
        vistaCanasta.layer.shadowRadius = 2
        lblProductosCanasta.layer.cornerRadius = 15/2
        lblProductosCanasta.clipsToBounds = true
        
        
        lblCategoryName.text = location?.name
        lblDate.text = location?.schedule
        lblLocation.text = location?.distance ?? ""
        
        if let image = location?.imgURL {
            imgBaner.kf.setImage(with: URL(string: image),
                                      placeholder: nil,
                                      options: [.transition(.fade(0.4))],
                                      progressBlock: nil,
                                      completionHandler: nil)
        }
        
        imgBaner.addShadow()
        imgBaner.layer.cornerRadius = self.imgBaner.frame.size.width / 2
        imgBaner.clipsToBounds = true
        
        vistaLogo.layer.cornerRadius = self.vistaLogo.frame.size.width / 2
        vistaLogo.layer.shadowColor = UIColor.gray.cgColor
        vistaLogo.layer.shadowOffset = CGSize(width: 0, height: 6)
        vistaLogo.layer.shadowOpacity = 0.4
        vistaLogo.layer.shadowRadius = 6
        
        vistaCanasta.visibility = .gone
        
        requestData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getProductosCanasta()
    }
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func verCanastaAction(_ sender: UIButton) {
        let viewController = UIStoryboard.shoppingCart.instantiate(ShoppingCartV2ViewController.self)
       
        viewController.location = self.location
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func getProductosCanasta(){
        var data = Constatns.LocalData.canasta
        if data != nil {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                var canasta = try decoder.decode([pedidoObject].self, from: data!)
                
                var idcategoriaInt = Int(self.location?.id ?? "0")!
                
               
                var arrProductosEncanasta : [pedidoObject] = [pedidoObject]()
                for item in canasta {
                    if item.negocioId == idcategoriaInt {
                        arrProductosEncanasta.append(item)
                    }
                }
                print("numero de productos: \(arrProductosEncanasta.count)")
                if arrProductosEncanasta.count == 0 {
                    self.vistaCanasta.visibility = .gone
                }
                else {
                    self.vistaCanasta.visibility = .visible
                    self.lblProductosCanasta.text = "\(arrProductosEncanasta.count)"
                }

            } catch {
                print("Unable to Decode pedido (\(error))")
            }
        }
        else {
            print("no hay produictos en la canasta")
        }
    }
    
    func requestData() {
        guard let locationId = locationId else { return }
        print(locationId)
        loader.showInView(aView: view, animated: true)
        CategoriesFetcher.fetchCategories(locationId: locationId) { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error):
                print(error)
            case .success(let categories):
                self?.categories = categories
                self?.collectionView.reloadData()
            }
        }
    }
}

extension CategoriesV2ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryV2CollectionViewCell
        let category = categories[indexPath.row]
        
        /*cell.imgCategory.layer.cornerRadius = cell.imgCategory.layer.frame.width / 2
        cell.imgCategory.layer.masksToBounds = false
        cell.imgCategory.clipsToBounds = true*/
        
        cell.lblName.text = category.name
        if let image = category.imageURL {
            cell.imgCategory.kf.setImage(with: URL(string: image),
                                           placeholder: nil,
                                           options: [.transition(.fade(0.4))],
                                           progressBlock: nil,
                                           completionHandler: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        /*
        let viewController = UIStoryboard.products.instantiate(ProductsContainerViewController.self)
        viewController.businessId = businessId
        viewController.locationId = locationId
        viewController.categoryId = category.id
        viewController.location = location
        navigationController?.pushViewController(viewController, animated: true)*/
        
        let viewController = UIStoryboard.products.instantiate(ProductosV2ViewController.self)
        viewController.businessId = businessId
        viewController.locationId = locationId
        viewController.categoryId = category.id
        viewController.location = location
        viewController.locationName = category.name ?? ""
        navigationController?.pushViewController(viewController, animated: true)
        
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

extension UIView {
func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
