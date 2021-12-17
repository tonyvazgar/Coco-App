//
//  PaymentsContainerViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/17/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class PaymentsContainerViewController: UIViewController, SideMenuDelegate {
    @IBOutlet private var topBar: UIView!
    @IBOutlet private var menuButton: UIButton!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var addPaymentMethodView: UIView!
    @IBOutlet private var addPaypalView: UIView!
    @IBOutlet private var addCocoCardView: UIView!
    
    private lazy var paymentListViewController: PaymentListViewController = {
        PaymentListViewController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        configureAddButtons()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @IBAction private func menuButtonAction(_ sender: Any) {
        let vc = UIStoryboard.sideMenu.instantiate(SideMenuViewController.self)
        vc.delegate = self
        addChild(vc)
        vc.showInView(aView: view)
    }
    
    @objc private func addPaymentButtonAction(_ sender: Any) {
        let vc = UIStoryboard.payments.instantiate(AddPaymentMethodViewController.self)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func addCocoCardButtonAction(_ sender: Any) {
        let vc = UIStoryboard.payments.instantiate(CocoCardsViewController.self)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Configure View

private extension PaymentsContainerViewController {
    func configureContentView() {
        paymentListViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(paymentListViewController)
        containerView.addSubview(paymentListViewController.view)
        NSLayoutConstraint.activate([
            paymentListViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            paymentListViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            paymentListViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            paymentListViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    func configureAddButtons() {
        [addPaymentMethodView, addPaypalView, addCocoCardView].forEach {
            $0?.addBorder(thickness: 1, color: .cocoGrayBorder)
            $0?.roundCorners(8)
        }
        
        addPaymentMethodView.addTap(#selector(addPaymentButtonAction(_:)), tapHandler: self)
        addCocoCardView.addTap(#selector(addCocoCardButtonAction(_:)), tapHandler: self)
    }
}

// MARK: - Add new payment delegate

extension PaymentsContainerViewController: AddPaymentMethodDelegate {
    func didAddCard() {
        paymentListViewController.requestData()
    }
}
