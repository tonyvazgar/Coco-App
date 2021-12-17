//
//  ProductDetailViewControlller.swift
//  Coco
//
//  Created by Carlos Banos on 10/11/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import SnapKit
import StickyScrollView

class ProductDetailViewControlller: UIViewController {
    
//    @IBOutlet private var shoppingCartBtn: UIButton!
    @IBOutlet private var favoriteButton: UIButton!
//    @IBOutlet private var countShoppingCart: UILabel!
    
    @IBOutlet private var productImageView: UIImageView!
    @IBOutlet private var productNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var cocopointsLabel: UILabel!
    
    @IBOutlet private var quantityLabel: UILabel!
    @IBOutlet private var lessQuantityButton: UIButton!
    @IBOutlet private var addQuantityButton: UIButton!
    
    @IBOutlet private var addToCartButton: UIButton!
    @IBOutlet private var quantityView: UIView!
    @IBOutlet private var subtotalView: UIView!
    @IBOutlet private var subtotalLabel: UILabel!
    
    @IBOutlet private var cartSummaryView: UIView!
    @IBOutlet private var cartContainerView: UIView!
    @IBOutlet private var cartItemCountLabel: UILabel!
    @IBOutlet private var cartAmountLabel: UILabel!
    
    var productId: String?
    var cost: Double?
    var quantity: Int = 1 {
        didSet {
            updateQuantity()
        }
    }
    var originalQuantity: Int = 0
    
    private var loader: LoaderVC!
    private var product: Product?
    private var shoppingCart: ShoppingCart?
    var location: LocationsDataModel?
    
    private var favorite: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        requestData()
        configureCartView()
        
        if let cartProduct = CartManager.instance.cart?.products.first(where: { $0.id == productId }),
           let qty = cartProduct.quantity, let qtyInt = Int(qty) {
            quantity = qtyInt
            originalQuantity = qtyInt
        }
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
        guard let product = product else { return }
        if originalQuantity == quantity {
            if CartManager.instance.addToCart(location: location, product: product, quantity: 1) {
                showAlertMessageAutoClose(mssg: "¡Producto agregado a canasta!")
            }
        } else {
            if CartManager.instance.setProductToCart(location: location, product: product, quantity: quantity) {
                showAlertMessageAutoClose(mssg: "¡Producto agregado a canasta!")
            }
        }
        
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        product?.requestStatusFavorite(status: favorite ? "1" : "0") { result in
            switch result {
            case .failure(let errorMssg):
                self.showAlertMessage(mssg: errorMssg)
            case .success(_):
                if self.favorite == true {
                    self.favoriteButton.setImage(#imageLiteral(resourceName: "favorite_menu"), for: .normal)
                    self.favorite = false
                    self.showAlertMessageAutoClose(mssg: "El producto ha sido eliminado de favoritos")
                } else {
                    self.favoriteButton.setImage(#imageLiteral(resourceName: "favorite_full"), for: .normal)
                    self.favorite = true
                    self.showAlertMessageAutoClose(mssg: "El producto ha sido agregado a favoritos")
                }
            }
        }
    }
    
    private func updateQuantity() {
        quantityLabel.text = "\(quantity)"
        
        guard let cost = cost else { return }
        let price = String(format: "%.2f", cost * Double(quantity))
        subtotalLabel.text = "$ \(price)"
    }
}

// MARK: - Initial Setup

private extension ProductDetailViewControlller {
    func configureView() {
        addToCartButton.roundCorners(12)
        quantityLabel.addBorder(thickness: 1, color: .lightGray)
        quantityLabel.roundCorners(8)
        
        productImageView.roundCorners(productImageView.frame.width/2)
        
        quantityView.backgroundColor = .cocoLightGray
        quantityView.layer.borderColor = UIColor.cocoOrange.cgColor
        quantityView.layer.borderWidth = 1
        
        subtotalView.layer.borderColor = UIColor.cocoLightGray.cgColor
        subtotalView.layer.borderWidth = 1
        
        quantityView.roundCorners(8)
        subtotalView.roundCorners(8)
    }
    
    func requestData() {
        guard let productId = productId else { return }
        showLoader(&loader, view: view)
        ProductsFetcher.fetchProductDetail(productId: productId) { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error):
                self?.throwError(str: error.localizedDescription)
            case .success(let product):
                self?.product = product
                self?.fillInfo()
            }
        }
    }
}

// MARK: - Populate view

private extension ProductDetailViewControlller {
    func fillInfo() {
        productNameLabel.text = product?.name
        descriptionLabel.text = product?.description
        priceLabel.text = "$\(product?.price ?? "")"
        cocopointsLabel.text = "\(product?.cocopoints ?? 0)"
        
        if let isProductFavorite = product?.favorite, isProductFavorite == "1" {
            favoriteButton.setImage(#imageLiteral(resourceName: "favorite_full"), for: .normal)
            favorite = true
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "favorite_empty"), for: .normal)
            favorite = false
        }
        
        guard let image = product?.imageURL else { return }
        productImageView.setImageKf(str: image)
        
        if let price = product?.price {
            cost = Double(price)
            updateQuantity()
        }
    }
}

// MARK: - Alerts

private extension ProductDetailViewControlller {
    func showAlertMessage(mssg: String) {
        let alert = AlertModal()
        addChild(alert)
        alert.showInView(aView: view, text: mssg)
    }
    
    func showAlertMessageAutoClose(mssg: String) {
        let alert = AlertModal()
        addChild(alert)
        alert.showInView(aView: view, text: mssg)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.removeAnimate()
        }
    }
}


// MARK: - Cart configure

private extension ProductDetailViewControlller {
    func configureCartView() {
        cartItemCountLabel.roundCorners(8)
        cartContainerView.clipsToBounds = true
        cartContainerView.layer.cornerRadius = 10
        cartContainerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        cartItemCountLabel.text = "\(CartManager.instance.totalItems)"
        cartContainerView.addTap(#selector(openCart), tapHandler: self)
        
        if let amount = CartManager.instance.cart?.sub_amount {
            cartAmountLabel.text = String(format: "$ %0.2f", Double(amount) ?? 0.0)
        } else {
            cartAmountLabel.text = "$ --"
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cartDidChange),
                                               name: .cartDidChange,
                                               object: nil)
    }
    
    @objc func openCart() {
        let vc = UIStoryboard.shoppingCart.instantiate(ShoppingCartViewController.self)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func cartDidChange() {
        cartItemCountLabel.text = "\(CartManager.instance.totalItems)"
        if let amount = CartManager.instance.cart?.sub_amount {
            cartAmountLabel.text = String(format: "$ %0.2f", Double(amount) ?? 0.0)
        } else {
            cartAmountLabel.text = "$ --"
        }
        
        if let cartProduct = CartManager.instance.cart?.products.first(where: { $0.id == productId }),
           let qty = cartProduct.quantity, let qtyInt = Int(qty) {
            quantity = qtyInt
            originalQuantity = qtyInt
        } else {
            originalQuantity = 0
        }
    }
}
