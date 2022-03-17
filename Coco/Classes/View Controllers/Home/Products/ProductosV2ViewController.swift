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
    
    
    @IBOutlet weak var imgCanasta: UIImageView!
    @IBOutlet weak var vistaCanasta: UIView!
    @IBOutlet weak var btnCanasta: UIButton!
    @IBOutlet weak var lblProductosCanasta: UILabel!
    
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
        
        //--Canasta
        vistaCanasta.layer.cornerRadius = 15
        btnCanasta.layer.cornerRadius = 15
        btnCanasta.clipsToBounds = true
        
        
        vistaCanasta.layer.shadowColor = UIColor.gray.cgColor
        vistaCanasta.layer.shadowOffset = CGSize(width: 0, height: 3)
        vistaCanasta.layer.shadowOpacity = 0.4
        vistaCanasta.layer.shadowRadius = 2
        lblProductosCanasta.layer.cornerRadius = 15/2
        lblProductosCanasta.clipsToBounds = true
        //________
        
        tableView.register(UINib(nibName: "ProductV2TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        vistaCanasta.visibility = .gone
        requestData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let id = UserManagement.shared.id_user ?? ""
        if id == "" {
            self.vistaCanasta.visibility = .gone
        }
        else {
            getProductosCanasta()
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func irACanastaAction(_ sender: UIButton) {
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
        viewController.categoryId = self.categoryId!
        
        print("Id producto que se envia:\(product.id)")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
