//
//  ProductDetailVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/2/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import SnapKit
import StickyScrollView

class ProductDetailVC: UIViewController {
    
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var shoppingCartBtn: UIButton!
    @IBOutlet weak var scroll: StickyScrollView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cocopointsLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var lessQuantityButton: UIButton!
    @IBOutlet weak var addQuantityButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var countShoppingCart: UILabel!
    
    var quantity: Int = 1 {
        didSet {
            quantityLabel.text = "\(quantity)"
        }
    }
    
    var loader: LoaderVC!
    var product: Product!
    var shoppingCart: ShoppingCart?
    
    private var favorite: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        requestData()
        print("This is the one")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getShoppingCart()
    }
    
    private func getShoppingCart() {
        if let cart = UserDefaults.standard.data(forKey: "shoppingCart") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(ShoppingCart.self, from: cart) {
                shoppingCart = decoded
                countShoppingCart.text = "\(decoded.products.count)"
            } else {
                displayShoppingCart(show: false)
            }
        } else {
            displayShoppingCart(show: false)
        }
    }
    
    private func displayShoppingCart(show: Bool) {
        countShoppingCart.isHidden = !show
    }
    
    private func configureView() {
        addToCartButton.roundCorners(12)
        quantityLabel.addBorder(thickness: 1, color: .lightGray)
        quantityLabel.roundCorners(8)
        countShoppingCart.backgroundColor = .CocoBlack
        countShoppingCart.circleBorders()
        countShoppingCart.textColor = .white
    }
    
    private func requestData() {
        showLoader(&loader, view: view)
        product.requestProductDetail { result in
            self.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self.throwError(str: errorMssg)
            case .success(_):
                self.fillInfo()
            }
        }
    }
    
    private func fillInfo() {
        productNameLabel.text = product.name
        descriptionLabel.text = product.description
        priceLabel.text = "Precio: $\(product.price ?? "")"
        cocopointsLabel.text = "Cocopoints: \(product.cocopoints ?? 0)"
        
        if product.favorite != nil && product.favorite == "1" {
            favoriteButton.setImage(#imageLiteral(resourceName: "favorite"), for: .normal)
            favorite = true
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "nofavorite"), for: .normal)
            favorite = false
        }
        
        guard let image = product.imageURL else { return }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        imageView.setImageKf(str: image)
        scroll.setStickyImage(imageView: imageView)
        scroll.setStickyDisplayHeight(height: 200)
        
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(220)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shoppingCartAction(_ sender: Any) {
        let vc = ShoppingCartVC()
        presentAsync(vc)
    }
    
    @IBAction func lessQuantityAction(_ sender: Any) {
        if quantity >= 2 {
            quantity -= 1
        }
    }
    
    @IBAction func addQuantityAction(_ sender: Any) {
        if quantity <= 9 {
            quantity += 1
        }
    }
    
    @IBAction func addToCartAction(_ sender: Any) {
        if shoppingCart != nil {
            if shoppingCart?.id_store == product.id_store {
                product.quantity = "\(quantity)"
                shoppingCart!.addProduct(product: product)
            } else {
                shoppingCart = ShoppingCart(id_store: product.id_store, store_name: product.business)
                product.quantity = "\(quantity)"
                shoppingCart!.addProduct(product: product)
            }
            countShoppingCart.text = "\(shoppingCart?.products.count ?? 1 + 1)"
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(shoppingCart) {
                UserDefaults.standard.set(encoded, forKey: "shoppingCart")
                showAlertMessageAutoClose(mssg: "¡Producto agregado a canasta!")
            }
        } else {
            displayShoppingCart(show: true)
            countShoppingCart.text = "1"
            shoppingCart = ShoppingCart(id_store: product.id_store, store_name: product.business)
            product.quantity = "\(quantity)"
            shoppingCart!.addProduct(product: product)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(shoppingCart) {
                UserDefaults.standard.set(encoded, forKey: "shoppingCart")
                showAlertMessageAutoClose(mssg: "¡Producto agregado a canasta!")
            }
        }
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        product.requestStatusFavorite(status: favorite ? "1" : "0") { result in
            switch result {
            case .failure(let errorMssg):
                self.showAlertMessage(mssg: errorMssg)
            case .success(_):
                if self.favorite == true {
                    self.favoriteButton.setImage(#imageLiteral(resourceName: "nofavorite"), for: .normal)
                    self.favorite = false
                    self.showAlertMessageAutoClose(mssg: "El producto ha sido eliminado de favoritos")
                } else {
                    self.favoriteButton.setImage(#imageLiteral(resourceName: "favorite"), for: .normal)
                    self.favorite = true
                    self.showAlertMessageAutoClose(mssg: "El producto ha sido agregado a favoritos")
                }
            }
        }
    }
    
    private func showAlertMessage(mssg: String) {
        let alert = AlertModal()
        addChild(alert)
        alert.showInView(aView: view, text: mssg)
    }
    
    private func showAlertMessageAutoClose(mssg: String) {
        let alert = AlertModal()
        addChild(alert)
        alert.showInView(aView: view, text: mssg)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.removeAnimate()
        }
    }
}
