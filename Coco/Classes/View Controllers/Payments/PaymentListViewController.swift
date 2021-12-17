//
//  PaymentListViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/17/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class PaymentListViewController: UITableViewController {
    private(set) var paymentMethods: [PaymentForm] = []
    private var loader = LoaderVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.showInView(aView: view, animated: true)
        requestData()
        configureTableView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        paymentMethods.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPaymentsTableViewCell.cellIdentifier, for: indexPath) as? MyPaymentsTableViewCell else {
            return UITableViewCell()
        }
        
        let method = paymentMethods[indexPath.row]
        cell.nameLabel.text = "**** **** **** \(method.digits ?? "****")"
        cell.index = indexPath.row
        cell.delegate = self
        
        if let type = method.type {
            let imageName: String
            switch type {
            case "VISA": imageName = "visa_sola"
            case "MASTER CARD": imageName = "mastercard"
            case "AMEX": imageName = "amex"
            default: imageName = "visa_sola"
            }
            cell.iconImageView.image = UIImage(named: imageName)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let location = locations[indexPath.row]
//        let viewController = UIStoryboard.home.instantiate(CategoriesContainerViewController.self)
//        viewController.businessId = businessId
//        viewController.locationId = location.id
//        viewController.location = location
//        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Configure Table

private extension PaymentListViewController {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: MyPaymentsTableViewCell.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MyPaymentsTableViewCell.cellIdentifier)
    }
}

// MARK: - Fetch Businesses

extension PaymentListViewController {
    func requestData() {
        PaymentMethodsFetcher.fetchPaymentMethods { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error):
                print(error)
            case .success(let paymentMethods):
                self?.paymentMethods = paymentMethods
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - MyPayments Cell delegate

extension PaymentListViewController: MyPaymentsCellDelegate {
    func didPressActionButton(_ index: Int) {
        let payment = paymentMethods[index]
        let cardID = payment.id
        let lastDigits = payment.digits
        let type = payment.type
        
        // Register Nib
        let newViewController = UIStoryboard.payments.instantiate(rechargeCreditViewController.self)

        newViewController.cardID = cardID
        newViewController.digits = lastDigits
        newViewController.typeOfCard = type
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func didPressRemoveButton(_ index: Int) {
        let alert = UIAlertController(title: "¿Deseas eliminar esta tarjeta de tu perfil?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Si", style: .default) { [weak self] _ in
            self?.loader.showInView(aView: self?.view, animated: true)
            let paymentForm = self?.paymentMethods[index]
            paymentForm?.removePaymentForm { result in
                switch result {
                case .failure(let error):
                    self?.throwError(str: error)
                case .success(_):
                    self?.requestData()
                }
            }
        })
        present(alert, animated: true)
    }
}
