//
//  CategoriesContainerViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/9/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class CategoriesContainerViewController: UIViewController {
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var headerContainerView: UIView!
    @IBOutlet private var balanceView: UIView!
    @IBOutlet private var balanceLabel: UILabel!
    @IBOutlet private var cocopointsView: UIView!
    @IBOutlet private var cocopointsLabel: UILabel!
    
    var businessId: String?
    var locationId: String?
    var location: LocationsDataModel?
    
    @IBAction private func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTopBarView()
        configureHeaderView()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

// MARK: - Configure View

private extension CategoriesContainerViewController {
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
        configureContentView()
    }
    
    func configureContentView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 32, bottom: 0, right: 32)
        flowLayout.itemSize = CGSize(width: 140, height: 150)
        
        let viewController = CategoriesListViewController(collectionViewLayout: flowLayout)
        viewController.businessId = businessId
        viewController.locationId = locationId
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
