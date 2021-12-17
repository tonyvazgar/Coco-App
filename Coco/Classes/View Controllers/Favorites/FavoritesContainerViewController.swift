//
//  FavoritesContainerViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/18/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class FavoritesContainerViewController: UIViewController {
    @IBOutlet private var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction private func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Configure View

private extension FavoritesContainerViewController {
    func configureContentView() {
        let viewController = FavoritesListViewController()
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
