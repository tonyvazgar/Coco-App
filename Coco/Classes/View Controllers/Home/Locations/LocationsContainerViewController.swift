//
//  LocationsContainerViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/9/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class LocationsContainerViewController: UIViewController {
    @IBOutlet private var sectionTitleLabel: UILabel!
    @IBOutlet private var containerView: UIView!
    
    var textoSeccion = "";
    
    var businessId: String?
    
    @IBAction private func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func configureContentView() {
        let viewController = LocationsListViewController()
        viewController.businessId = businessId
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(viewController)
        containerView.addSubview(viewController.view)
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        sectionTitleLabel.text = textoSeccion
    }
}
