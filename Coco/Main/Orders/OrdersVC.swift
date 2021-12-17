//
//  OrdersVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

class OrdersVC: UIViewController, showMeTheCoco, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var table: UITableView!
    
    var loader: LoaderVC!
    var orders: Orders!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orders = Orders()
        configureTable()
        requestData()
    }
    
    func showsTheCoco(position: UIView) {
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popoverID")
        popController.modalPresentationStyle = .overCurrentContext
        popController.modalPresentationStyle = .popover
        popController.modalTransitionStyle = .crossDissolve
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.left
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = position
        popController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 130, height: 65)
        self.present(popController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle { return UIModalPresentationStyle.none
    }
    
    private func configureTable() {
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        let nib = UINib(nibName: OrderTableViewCell.cellIdentifier, bundle: nil)
        table.register(nib, forCellReuseIdentifier: OrderTableViewCell.cellIdentifier)
    }
    
    private func requestData() {
        showLoader(&loader, view: view)
        orders.requestOrders { result in
            self.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self.throwError(str: errorMssg)
            case .success(_):
                self.fillInfo()
            }
        }
    }
    
    private func fillInfo() {
        table.reloadData()
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension OrdersVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.cellIdentifier, for: indexPath) as? OrderTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        let item = orders.orders[indexPath.row]
        cell.orderNumber.text = "Orden \(item.id ?? "--")"
        cell.dateLabel.text = "Fecha: \(item.date ?? "--")"
        cell.statusLabel.text = "\(item.status ?? "--")"
        cell.businessLabel.text = "\(item.business ?? "--")"
        let otorgados = item.cocopointsOtorgados
        let otorgadosDouble = Double("\(otorgados ?? "0")")
        let otorgadosInt = Int(otorgadosDouble ?? 0)
        
//        if otorgadosInt == 0 {
//            cell.buttonShowCoco.isHidden = true
//        }
//        
//        if otorgadosInt != 0 {
//            cell.buttonShowCoco.isHidden = false
//            cell.buttonShowCoco.tag = otorgadosInt
//        }
        
        if item.tipoDeCompra == "1" {
            cell.amountLabel.text = item.total
            cell.montoCocoLabel.text = "Monto"
        } else if item.tipoDeCompra == "2" {
            cell.montoCocoLabel.text = "Cocopoints"
            cell.amountLabel.text = item.totalCocopoints
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = instantiate(viewControllerClass: OrderDetail.self,
                             storyBoardID: "OrderDetail",
                             storyBoardName: "OrderStoryboard")
        vc.order = orders.orders[indexPath.row]
        presentAsync(vc)
    }
}

extension TimeInterval {
    var minuteSecondMS: String {
        return String(format:"%d mins %02d segs", minute, second, millisecond)
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}

extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}
