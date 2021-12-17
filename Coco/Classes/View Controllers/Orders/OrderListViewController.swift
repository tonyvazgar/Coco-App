//
//  OrderListViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/19/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class OrderListViewController: UITableViewController {
    private(set) var orders: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        configureTableView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.cellIdentifier, for: indexPath) as? OrderTableViewCell else {
            return UITableViewCell()
        }
        
        let order = orders[indexPath.row]
        cell.orderNumber.text = "Orden \(order.id ?? "--")"
        cell.dateLabel.text = "Fecha: \(order.date ?? "--")"
        cell.statusLabel.text = "\(order.status ?? "--")"
        cell.businessLabel.text = "\(order.business ?? "--")"
        if order.tipoDeCompra == "1" {
            cell.amountLabel.text = order.total
            cell.montoCocoLabel.text = "Monto"
        } else if order.tipoDeCompra == "2" {
            cell.montoCocoLabel.text = "Cocopoints"
            cell.amountLabel.text = order.totalCocopoints
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = orders[indexPath.row]
        let viewController = UIStoryboard.orders.instantiate(OrderDetailViewController.self)
        viewController.orderId = order.id
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Configure Table

private extension OrderListViewController {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: OrderTableViewCell.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: OrderTableViewCell.cellIdentifier)
    }
}

// MARK: - Fetch Businesses

private extension OrderListViewController {
    func requestData() {
        OrdersFetcher.fetchOrders { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let orders):
                self?.orders = orders
                self?.tableView.reloadData()
            }
        }
    }
}

