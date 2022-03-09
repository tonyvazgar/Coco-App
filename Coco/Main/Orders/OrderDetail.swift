//
//  OrderDetail.swift
//  Coco
//
//  Created by Carlos Banos on 7/19/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import SnapKit

class OrderDetail: UIViewController {
  @IBOutlet weak var topBar: UIView!
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var scroll: UIScrollView!
  @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var amountLabels: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var cocopointsLabels: UILabel!
    @IBOutlet weak var cocopoints: UILabel!
  @IBOutlet weak var table: UITableView!
  @IBOutlet weak var tip: UIButton!
  @IBOutlet weak var orderDescription: UITextView!
  @IBOutlet weak var heightTable: NSLayoutConstraint!
  @IBOutlet weak var tipLabel: UILabel!
    
  var loader: LoaderVC!
  var ordersDetail: OrdersDetail!
  var order: Order!
  var orders: Orders!

  override func viewDidLoad() {
    super.viewDidLoad()
    checkTypeOfOrder()
    configureView()
    configureTable()
    requestData()
  }
  
  private func requestData() {
    ordersDetail = OrdersDetail(order: order)
    ordersDetail.requestOrders { result in
      switch result {
      case .failure(let errorMssg):
        self.throwError(str: errorMssg)
        return
      case .success(_):
        self.fillInfo()
        self.table.delegate = self
        self.table.dataSource = self
        self.table.reloadData()
      }
    }
  }
  
  private func fillInfo() {
    businessName.text = ordersDetail.order.business
    amount.text = ordersDetail.order.total
    cocopoints.text = order.totalCocopoints
    //orderDescription.text = ordersDetail.order.comments
    guard let tipPercentage = ordersDetail.order.tipPercentage else {
      tip.setTitle("0 %", for: .normal)
      return
    }
    tip.setTitle("\(tipPercentage) %", for: .normal)
  }
  
  private func configureTable() {
    table.tableFooterView = UIView()
    let nib = UINib(nibName: OrderProductTableViewCell.cellIdentifier, bundle: nil)
    table.register(nib, forCellReuseIdentifier: OrderProductTableViewCell.cellIdentifier)
  }
  
  private func configureView() {
    backView.setShadow()
    backView.roundCorners(15)
    
    tip.circleBorders()
    tip.addBorder(thickness: 2, color: .CocoBlack)
    
    orderDescription.addBorder(thickness: 1, color: .CocoBlack)
  }
    
    func checkTypeOfOrder() {
    
        if order.tipoDeCompra == "1" {
            
            cocopointsLabels.isHidden = true
            cocopoints.isHidden = true
            
        }
        
        if order.tipoDeCompra == "2" {
            
            let totaldeCocos = "\(order.totalCocopoints ?? "")"
            
            amountLabels.isHidden = true
            amount.isHidden = true
            tipLabel.isHidden = true
            tip.isHidden = true
            cocopoints.text = totaldeCocos
            
            print("BITCHES")
            print(totaldeCocos)
            print(order.totalCocopoints)
        }
        
    }
    
  @IBAction func backBtn(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}

extension OrderDetail: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ordersDetail.products.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderProductTableViewCell.cellIdentifier, for: indexPath) as? OrderProductTableViewCell else {
      return UITableViewCell()
    }
    
    let item = ordersDetail.products[indexPath.row]
    cell.productName.text = item.name
    var priceFloat: Float = 0.0
    if let price = item.price {
      cell.price.text = price
      priceFloat = NumberFormatter().number(from: price)?.floatValue ?? 10.0
    }
    
    var quantityFloat: Float = 0.0
    if let quantity = item.quantity {
      cell.quantity.text = quantity
      quantityFloat = NumberFormatter().number(from: quantity)?.floatValue ?? 1
    }
    cell.total.text = "\(quantityFloat * priceFloat)"
    cell.index = indexPath.row
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}
