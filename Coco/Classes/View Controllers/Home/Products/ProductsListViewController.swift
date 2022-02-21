//
//  ProductsListViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/9/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class ProductsListViewController: UITableViewController {
    private(set) var products: [ProducItem] = []
    private var loader = LoaderVC()
    var location: LocationsDataModel?
    var businessId: String?
    var locationId: String?
    var categoryId: String?
    var cart = CartManager.instance.cart
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        configureTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(cartDidChange), name: .cartDidChange, object: nil)
    }
    
    @objc private func cartDidChange() {
        cart = CartManager.instance.cart
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.cellIdentifier, for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        
        let product = products[indexPath.row]
        cell.productNameLabel.text = product.name
        cell.productDescriptionLabel.text = product.description
        if let price = product.price {
            if let amountPrice = Double(price) {
                cell.productPriceLabel.text = "$ " + (String(format: "%0.2f", amountPrice))
            } else {
                cell.productPriceLabel.text = "$ " + (price)
            }
        } else {
            cell.productPriceLabel.text = "$ --"
        }
        cell.index = indexPath.row
        cell.delegate = self
        if let image = product.imageURL {
            cell.productImageView.kf.setImage(with: URL(string: image),
                                           placeholder: nil,
                                           options: [.transition(.fade(0.4))],
                                           progressBlock: nil) { (image, _, _, _) in
                if let image = image {
                    let width = image.size.width
                    let height = image.size.height
                    
                    if width > height {
                        cell.imageHeight.constant = (90 * height) / width
                        cell.layoutIfNeeded()
                    } else if width < height {
                        cell.imageWidth.constant = (90 * width) / height
                        cell.layoutIfNeeded()
                    }
                }
            }
        }
        
        if let cartProduct = cart?.products.first(where: { $0.id == product.id }) {
            cell.quantityLabel.text = cartProduct.quantity
            cell.quantityLabel.isHidden = false
        } else {
            cell.quantityLabel.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        let viewController = UIStoryboard.products.instantiate(ProductDetailViewControlller.self)
        viewController.productId = product.id
        viewController.location = location
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Configure Table

private extension ProductsListViewController {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: ProductTableViewCell.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ProductTableViewCell.cellIdentifier)
    }
}

extension ProductsListViewController: ProductCellDelegate {
    func didAddProduct(index: Int) {
        let product = products[index]
      //  if CartManager.instance.addToCart(location: location, product: product, quantity: 1) { }
    }
}

// MARK: - Fetch Businesses

private extension ProductsListViewController {
    func requestData() {
        guard let locationId = locationId, let categoryId = categoryId else { return }
        loader.showInView(aView: view, animated: true)
        
        
        ProductsFetcher.getProducts(locationId: locationId, categoryId: categoryId) { [weak self] result in
            self?.loader.removeAnimate()
            if result.state == "200" {
                self?.products = result.data ?? []
                self?.tableView.reloadData()
            }
            else {
                print(result.status_msg ?? "")
            }
        }
        
        
        /*
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
         */
         
    }
}
