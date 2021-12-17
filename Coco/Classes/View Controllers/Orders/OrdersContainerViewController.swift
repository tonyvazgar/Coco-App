//
//  OrdersContainerViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/19/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class OrdersContainerViewController: UIViewController {
    @IBOutlet private var sectionTitleLabel: UILabel!
    @IBOutlet private var containerView: UIView!
    
    @IBAction private func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configureContentView() {
        let viewController = OrderListViewController()
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

