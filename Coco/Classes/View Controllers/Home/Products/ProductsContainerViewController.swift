//
//  ProductsContainerViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/9/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class ProductsContainerViewController: UIViewController {
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var headerContainerView: UIView!
    @IBOutlet private var balanceView: UIView!
    @IBOutlet private var balanceLabel: UILabel!
    @IBOutlet private var cocopointsView: UIView!
    @IBOutlet private var cocopointsLabel: UILabel!
    
    @IBOutlet private var cartSummaryView: UIView!
    @IBOutlet private var cartContainerView: UIView!
    @IBOutlet private var cartItemCountLabel: UILabel!
    @IBOutlet private var cartAmountLabel: UILabel!
    
    var businessId: String?
    var locationId: String?
    var categoryId: String?
    var location: LocationsDataModel?
    
    @IBAction private func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTopBarView()
        configureHeaderView()
        configureContentView()
        configureCartView()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

// MARK: - Configure View

private extension ProductsContainerViewController {
    func configureTopBarView() {
        balanceView.roundCorners(15)
        cocopointsView.roundCorners(15)
        
        guard let user = UserManagement.shared.user else { return }
        balanceLabel.text = "Saldo: \n$\(user.current_balance ?? "--")"
        cocopointsLabel.text = "Cocopoints: \n\(user.cocopoints_balance ?? "--")"
    }
    
    func configureHeaderView() {
        let view = LocationHeaderView.instantiate()
        view.location = location
        headerContainerView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            view.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor)
        ])
    }
    
    func configureContentView() {
        let viewController = ProductsListViewController()
        viewController.businessId = businessId
        viewController.locationId = locationId
        viewController.categoryId = categoryId
        viewController.location = location
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(viewController)
        containerView.addSubview(viewController.view)
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
}

// MARK: - Cart configure

private extension ProductsContainerViewController {
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
    }
}

extension Notification.Name {
    static let cartDidChange = Notification.Name(rawValue: "CartDidChange")
}
