//
//  ProductosV2ViewController.swift
//  Coco
//
//  Created by Erick Monfil on 23/02/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class ProductosV2ViewController: UIViewController {
    
    var businessId: String?
    var locationId: String?
    var categoryId: String?
    var location: LocationsDataModel?
    var locationName : String = ""
    private(set) var products: [Product] = []
    private var loader = LoaderVC()
    
    
    @IBOutlet weak var lblCategorieName: UILabel!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgProducto: UIImageView!
    @IBOutlet weak var viewProduct: UIView!
    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundView.layer.cornerRadius = 30
        roundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        roundView.layer.shadowColor = UIColor.gray.cgColor
        roundView.layer.shadowOffset = CGSize(width: 0, height: -4)
        roundView.layer.shadowOpacity = 0.4
        roundView.layer.shadowRadius = 2
        
        lblNombre.text = location?.name
        lblDate.text = location?.schedule
        lblLocation.text = location?.distance
        lblCategorieName.text = locationName
        if let image = location?.imgURL {
            imgProducto.kf.setImage(with: URL(string: image),
                                      placeholder: nil,
                                      options: [.transition(.fade(0.4))],
                                      progressBlock: nil,
                                      completionHandler: nil)
        }
        
        imgProducto.layer.cornerRadius = self.imgProducto.frame.size.width / 2
        imgProducto.clipsToBounds = true
        
        viewProduct.layer.cornerRadius = self.viewProduct.frame.size.width / 2
        viewProduct.layer.shadowColor = UIColor.gray.cgColor
        viewProduct.layer.shadowOffset = CGSize(width: 0, height: 6)
        viewProduct.layer.shadowOpacity = 0.4
        viewProduct.layer.shadowRadius = 6
        
        tableView.register(UINib(nibName: "ProductV2TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        requestData()
    }
    

    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func requestData() {
        guard let locationId = locationId, let categoryId = categoryId else { return }
        loader.showInView(aView: view, animated: true)
        
        /*
        ProductsFetcher.getProducts(locationId: locationId, categoryId: categoryId) { [weak self] result in
            self?.loader.removeAnimate()
            if result.state == "200" {
                self?.products = result.data ?? []
                self?.tableView.reloadData()
            }
            else {
                print(result.status_msg ?? "")
            }
        }*/
        
        ProductsFetcher.fetchProducts(locationId: locationId, categoryId: categoryId) { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error):
                print(error)
            case .success(let products):
                self?.products = products
                print("numero de productor rescuperados:\(self?.products.count)")
                self?.tableView.reloadData()
            }
        }
    }
    
}


extension ProductosV2ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductV2TableViewCell
        let product = products[indexPath.row]
        cell.lblName.text = product.name ?? ""
        cell.lblDescripcion.text = product.description ?? ""
        if let price = product.price {
            if let amountPrice = Double(price) {
                cell.lblPrecio.text = "$ " + (String(format: "%0.2f", amountPrice))
            } else {
                cell.lblPrecio.text = "$ " + (price)
            }
        } else {
            cell.lblPrecio.text = "$ --"
        }
        
        if let image = product.imageURL {
            cell.imgLogo.kf.setImage(with: URL(string: image),
                                      placeholder: nil,
                                      options: [.transition(.fade(0.4))],
                                      progressBlock: nil,
                                      completionHandler: nil)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        
        /*
        let viewController = UIStoryboard.products.instantiate(ProductDetailViewControlller.self)
        viewController.productId = product.id
        viewController.location = location
        navigationController?.pushViewController(viewController, animated: true)*/
        
        let viewController = UIStoryboard.products.instantiate(ProducDetailV2ViewController.self)
        viewController.productId = product.id
        viewController.location = location
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
