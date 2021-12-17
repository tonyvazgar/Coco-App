//
//  OrderDetailViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/19/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class OrderDetailViewController: UIViewController {
    
    @IBOutlet private var orderNumberLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var table: UITableView!
    
    @IBOutlet private var tipLabel: UILabel!
    @IBOutlet private var orderDescriptionLabel: UILabel!
    @IBOutlet private var orderDetailView: UIView!
    @IBOutlet private var orderSummaryView: UIView!
    
    @IBOutlet private var orderTotalLabel: UILabel!
    @IBOutlet private var orderTotalView: UIView!
    
    @IBOutlet private var balanceView: UIView!
    @IBOutlet private var balanceLabel: UILabel!
    @IBOutlet private var cocopointsView: UIView!
    @IBOutlet private var cocopointsLabel: UILabel!
    
    private var orderDetail: OrdersDetail?
    var orderId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTable()
        configureTopBarView()
        requestData()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @IBAction private func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Configure View

private extension OrderDetailViewController {
    func configureView() {
        orderDetailView.layer.cornerRadius = 8
        orderDetailView.layer.borderWidth = 0.5
        orderDetailView.layer.borderColor = UIColor.lightGray.cgColor
        orderDetailView.layer.shadowColor = UIColor.black.cgColor
        orderDetailView.layer.shadowOffset = .zero
        orderDetailView.layer.shadowOpacity = 0.25
        orderDetailView.layer.shadowRadius = 2
        
        orderSummaryView.roundCorners(8)
        orderSummaryView.addBorder(thickness: 1, color: .cocoOrange)
        
        orderTotalView.roundCorners(8)
        orderTotalView.addBorder(thickness: 1, color: .cocoLightGray)
    }
    
    func configureTopBarView() {
        balanceView.roundCorners(8)
        cocopointsView.roundCorners(8)
        orderNumberLabel.roundCorners(orderNumberLabel.frame.height/2)
        
        guard let user = UserManagement.shared.user else { return }
        balanceLabel.text = "Saldo: \n$\(user.current_balance ?? "--")"
        cocopointsLabel.text = "Cocopoints: \n\(user.cocopoints_balance ?? "--")"
    }
    
    func configureTable() {
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.separatorInset = .zero
        table.separatorColor = .cocoGray
        
        let nib = UINib(nibName: OrderDetailProductTableViewCell.cellIdentifier, bundle: nil)
        table.register(nib, forCellReuseIdentifier: OrderDetailProductTableViewCell.cellIdentifier)
    }
    
    func fillInfo() {
        guard let orderDetail = orderDetail else { return }
        orderNumberLabel.text = "Orden \(orderDetail.order.id ?? "--")"
        dateLabel.text = "Fecha: \(orderDetail.order.date ?? "--")"
        statusLabel.text = "Estatus: \(orderDetail.order.status ?? "--")"
        locationLabel.text = "\(orderDetail.order.business ?? "--")"

        orderTotalLabel.text = orderDetail.order.total
        orderDescriptionLabel.text = orderDetail.order.comments
        guard let tipPercentage = orderDetail.order.tipPercentage else {
            tipLabel.text = "0 %"
          return
        }
        tipLabel.text = "\(tipPercentage) %"
    }
}

// MARK: - Requests

private extension OrderDetailViewController {
    func requestData() {
        guard let orderId = orderId else { return }
        OrdersFetcher.fetchOrderDetail(orderId: orderId) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.throwError(str: error.localizedDescription)
            case .success(let order):
                self?.orderDetail = order
                self?.fillInfo()
                self?.table.reloadData()
            }
        }
    }
}

// MARK: - UITableView

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDetail?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailProductTableViewCell.cellIdentifier, for: indexPath) as? OrderDetailProductTableViewCell else {
            return UITableViewCell()
        }
        
        if let item = orderDetail?.products[indexPath.row] {
            cell.productName.text = item.name
            var priceFloat: Float = 0.0
            if let price = item.price {
                cell.price.text = price
                guard let number = NumberFormatter().number(from: price) else {
                    throwError(str: "No se pudo obtener los datos de los productos, favor de contactar al administrador")
                    return UITableViewCell()
                }
                priceFloat = number.floatValue
            }
            
            var quantityFloat: Float = 0.0
            if let quantity = item.quantity {
                cell.quantity.text = quantity
                guard let number = NumberFormatter().number(from: quantity) else {
                    throwError(str: "No se pudo obtener los datos de los productos favor de contactar al administrador")
                    return UITableViewCell()
                }
                quantityFloat = number.floatValue
            }
            cell.total.text = "\(quantityFloat * priceFloat)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
