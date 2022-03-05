//
//  ShoppingCartViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/19/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class ShoppingCartViewController: UIViewController {
    enum PaymentType {
        case money, cocopoints
    }
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var topBar: UIView!
    @IBOutlet private var table: UITableView!
    @IBOutlet private var orderSummaryView: UIView!
    
    @IBOutlet private var amount: UILabel!
    @IBOutlet private var cocopoints: UILabel!
    @IBOutlet private var amountView: UIView!
    @IBOutlet private var cocopointsNumberView: UIView!
    
    @IBOutlet private var headerContainerView: UIView!
    @IBOutlet private var balanceView: UIView!
    @IBOutlet private var balanceLabel: UILabel!
    @IBOutlet private var cocopointsView: UIView!
    @IBOutlet private var cocopointsLabel: UILabel!
    
    @IBOutlet private var payWithMoneyButton: UIButton!
    @IBOutlet private var payWithCocoButton: UIButton!
    @IBOutlet private var payButton: UIButton!
    
    @IBOutlet private var paymentTitleLabel: UILabel!
    @IBOutlet private var tipContainerView: UIView!
    @IBOutlet private var tipView: UIView!
    
    @IBOutlet var tip5Percent: UIButton!
    @IBOutlet var tip10Percent: UIButton!
    @IBOutlet var tip15Percent: UIButton!
    private lazy var tipButtons: [UIButton] = {
       [tip5Percent, tip10Percent, tip15Percent]
    }()
    
    @IBOutlet private var orderDescriptionTextView: UITextView!
    @IBOutlet private var orderDescriptionView: UIView!
    
    private var loader: LoaderVC!
    private var shoppingCart: ShoppingCart?
    
    private var balance: String = "0.0"
    private var normalCost: String = "0.0"
    private var costInCocopoints: String = "0"
    private var cocopointsBalance: String = "0"
    
    private var paymentType: PaymentType = .money
    private var tipSelectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTopBarView()
        
        configureTable()
        getShoppingCart()
    }
    
    private func configureTable() {
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        let nib = UINib(nibName: ProductCartTableViewCell.cellIdentifier, bundle: nil)
        table.register(nib, forCellReuseIdentifier: ProductCartTableViewCell.cellIdentifier)
    }
    
    private func getShoppingCart() {
        if let cart = UserDefaults.standard.data(forKey: "shoppingCart") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(ShoppingCart.self, from: cart) {
                shoppingCart = decoded
                let value = Double("\(shoppingCart?.sub_amount ?? "")") ?? 0
                let oneThousand = 1000.0
                let valueCocopoints = value * oneThousand
                let textCocos = Float(valueCocopoints).clean
                
                normalCost = Float(value).clean
                amount.text = "$ "+normalCost
                cocopoints.text = textCocos
                costInCocopoints = "\(valueCocopoints)"
                configureHeaderView(with: shoppingCart?.location)
            }
        }
    }
    
    @IBAction private func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func payButtonAction(_ sender: Any) {
        switch paymentType {
        case .money:
            payWithMoney()
        case .cocopoints:
            payWithCocoPoints()
        }
    }
    
    @IBAction private func payBalanceButtonAction(_ sender: Any) {
        payButton.isHidden = false
        payWithCocoButton.isHidden = true
        payWithMoneyButton.isHidden = true
        
        paymentTitleLabel.isHidden = false
        paymentTitleLabel.text = "Agregar Propina al establecimiento"
        tipContainerView.isHidden = false
        orderDescriptionView.isHidden = false
        
        payButton.backgroundColor = .cocoGreen
        paymentType = .money
        
        tipButtons.enumerated().forEach {
            $0.element.tag = $0.offset
            $0.element.roundCorners($0.element.frame.height/2)
            $0.element.addBorder(thickness: 1.5, color: .black)
            $0.element.setTitleColor(.black, for: .normal)
            $0.element.backgroundColor = .white
            $0.element.addTarget(self, action: #selector(tipButtonAction(_:)), for: .touchUpInside)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scrollView.scrollToBottom()
        }
    }
    
    @IBAction private func payCocopointsButtonAction(_ sender: Any) {
        payButton.isHidden = false
        payWithCocoButton.isHidden = true
        payWithMoneyButton.isHidden = true
        paymentTitleLabel.isHidden = false
        paymentTitleLabel.text = "Pago con Cocopoints"
        orderDescriptionView.isHidden = false
        paymentType = .cocopoints
        payButton.backgroundColor = .cocoBrown
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scrollView.scrollToBottom()
        }
    }
    
    @objc
    private func tipButtonAction(_ sender: UIButton) {
        if sender.tag == tipSelectedIndex {
            tipSelectedIndex = nil
            tipButtons.forEach {
                $0.addBorder(thickness: 1.5, color: .black)
                $0.setTitleColor(.black, for: .normal)
                $0.backgroundColor = .white
            }
        } else {
            tipButtons.enumerated().forEach {
                if sender.tag == $0.offset {
                    $0.element.addBorder(thickness: 0, color: .clear)
                    $0.element.backgroundColor = .black
                    $0.element.setTitleColor(.white, for: .normal)
                    tipSelectedIndex = $0.offset
                } else {
                    $0.element.addBorder(thickness: 1.5, color: .black)
                    $0.element.setTitleColor(.black, for: .normal)
                    $0.element.backgroundColor = .white
                }
            }
        }
    }
}

// MARK: - Requests

private extension ShoppingCartViewController {
    func requestLocationData(with storeId: String?) {
        
    }
}

// MARK: - Configure View

private extension ShoppingCartViewController {
    func configureView() {
        amountView.roundCorners(8)
        cocopointsNumberView.roundCorners(8)
        orderSummaryView.roundCorners(16)
        payWithMoneyButton.roundCorners(16)
        payWithCocoButton.roundCorners(16)
        payButton.roundCorners(16)
        
        orderSummaryView.addBorder(thickness: 1, color: .cocoOrange)
        amountView.addBorder(thickness: 1, color: .cocoGrayBorder)
        cocopointsNumberView.addBorder(thickness: 1, color: .cocoOrange)
        orderDescriptionTextView.addBorder(thickness: 1, color: .cocoGrayBorder)
    }
    
    func configureTopBarView() {
        balanceView.roundCorners(15)
        cocopointsView.roundCorners(15)
        
        guard let user = UserManagement.shared.user else { return }
        balanceLabel.text = "Saldo: \n$\(user.current_balance ?? "--")"
        cocopointsLabel.text = "Cocopoints: \n\(user.cocopoints_balance ?? "--")"
        
        balance = user.current_balance ?? "0.0"
        cocopointsBalance = user.cocopoints_balance ?? "0"
    }
    
    func configureHeaderView(with location: LocationsDataModel?) {
        guard let location = location else { return }
        let view = LocationHeaderView.instantiate()
        view.location = location
        headerContainerView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            view.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor)
        ])
    }
}

// MARK: - Process Payments

private extension ShoppingCartViewController {
    private func payWithMoney() {
        
        
        guard let shoppingCart = shoppingCart else { return }
        let tip = tipSelectedIndex != nil ? (tipSelectedIndex! + 1) * 5 : 0
        shoppingCart.setService(percentage: tip)
        shoppingCart.comments = orderDescriptionTextView.text
        
        guard let dict = try? shoppingCart.asDictionary() else {
            return
        }
        
        var jsonText = ""
        var products = [[String: Any]]()
        for i in dict["products"] as! [[String: Any]] {
            var temp = [String: Any]()
            temp["id"] = i["Id"]
            temp["cantidad"] = i["cantidad"]
            if let price = i["precio"] as? String {
                if let amountPrice = Double(price) {
                    temp["precio"] = String(format: "%0.2f", amountPrice)
                } else {
                    temp["precio"] = price
                }
            }
            products.append(temp)
        }
    
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: products,
            options: .prettyPrinted
            ),
            let theJSONText = String(data: theJSONData,
                                     encoding: String.Encoding.ascii) {
            jsonText = theJSONText
        }
        
        let my_balance = NumberFormatter().number(from: balance)!
        let cost = NumberFormatter().number(from: shoppingCart.amount_final ?? "0.0")!
        
        if my_balance.floatValue < cost.floatValue {
            self.throwError(str: "Saldo insuficiente")
            return
        }
        
        showLoader(&loader, view: view)
        shoppingCart.saveOrder(products: jsonText, parameters: dict, completion: { result in
            self.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self.throwError(str: errorMssg)
                return
            case .success(_):
                UserDefaults.standard.set(false, forKey: "comingFromFriend")
                CartManager.instance.emptyCart()
                // Register Nib
                let newViewController = doneModalViewController(nibName: "doneModalViewController", bundle: nil)
                newViewController.modalPresentationStyle = .fullScreen

                // Present View "Modally"
                self.present(newViewController, animated: true, completion: nil)
            }
        })
    }
    
    private func payWithCocoPoints() {
        guard let shoppingCarts = shoppingCart else { return }
        guard let dict = try? shoppingCarts.asDictionary() else {
            return
        }
        
        var jsonText = ""
        var products = [[String: Any]]()
        for i in dict["products"] as! [[String: Any]] {
            var temp = [String: Any]()
            temp["id"] = i["Id"]
            temp["cantidad"] = i["cantidad"]
            if let price = i["precio"] as? String {
                if let amountPrice = Double(price) {
                    temp["precio"] = String(format: "%0.2f", amountPrice)
                } else {
                    temp["precio"] = price
                }
            }
            products.append(temp)
        }
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: products,
            options: .prettyPrinted
            ),
            let theJSONText = String(data: theJSONData,
                                     encoding: String.Encoding.ascii) {
            jsonText = theJSONText
        }
        
        let my_balance = NumberFormatter().number(from: cocopointsBalance)!
        let costTotal = NumberFormatter().number(from: costInCocopoints)!
        
        if my_balance.floatValue < costTotal.floatValue {
            self.throwError(str: "Saldo insuficiente")
            return
        }
        
        let normalCost1 = NumberFormatter().number(from: normalCost)!
        let cost = NumberFormatter().number(from: costInCocopoints)!
        let idStore = (shoppingCart?.id_store)!
        let comments = orderDescriptionTextView.text ?? ""
        
        let Parameters = [
            "funcion" : "saveOrderCocopointsPresent",
            "id_user" : UserManagement.shared.id_user!,
            "amount_final" : normalCost1,
            "amount_cocopoints": cost,
            "id_store" : idStore,
            "comments" : comments] as [String : Any]
        
        showLoader(&loader, view: view)
        shoppingCart!.saveOrder2(products: jsonText, parameters: Parameters, completion: { result in
            self.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self.throwError(str: errorMssg)
                return
            case .success(_):
                CartManager.instance.emptyCart()
//                UserDefaults.standard.set(false, forKey: "comingFromFriend")
//                UserDefaults.standard.set("", forKey: "estimatedValue")
                // Register Nib
                let newViewController = doneModalViewController(nibName: "doneModalViewController", bundle: nil)
                newViewController.modalPresentationStyle = .fullScreen
                // Present View "Modally"
                self.present(newViewController, animated: true, completion: nil)
            }
        })
    }
}

// MARK: - UITableView

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingCart?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCartTableViewCell.cellIdentifier, for: indexPath) as? ProductCartTableViewCell else {
            return UITableViewCell()
        }
        
        if let item = shoppingCart?.products[indexPath.row] {
            cell.productName.text = item.name
            if let image = item.imageURL {
                cell.productImageView.kf.setImage(with: URL(string: image),
                                               placeholder: nil,
                                               options: [.transition(.fade(0.4))],
                                               progressBlock: nil) { (image, _, _, _) in
                    if let image = image {
                        let width = image.size.width
                        let height = image.size.height
                        
                        if width > height {
                            cell.imageHeight.constant = (50 * height) / width
                            cell.layoutIfNeeded()
                        } else if width < height {
                            cell.imageWidth.constant = (50 * width) / height
                            cell.layoutIfNeeded()
                        }
                    }
                }
            }
            var priceFloat: Float = 0.0
            if let price = item.price {
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
            cell.price.text = String(format: "$ %0.2f", quantityFloat * priceFloat)
            cell.delegate = self
            cell.index = indexPath.row
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ShoppingCartViewController: ProductCartCellDelegate {
    func didDecreaseQuantity(index: Int) {
        guard let item = shoppingCart?.products[index],
              let quantityStr = item.quantity, let quantity = Int(quantityStr) else { return }
        
        if quantity == 1 { didTapDelete(index: index); return }
        CartManager.instance.updateQuantity(product: item, quantity: quantity - 1)
        shoppingCart = CartManager.instance.cart
        table.reloadData()
        refreshCart()
    }
    
    func didIncreaseQuantity(index: Int) {
        guard let item = shoppingCart?.products[index],
              let quantityStr = item.quantity, let quantity = Int(quantityStr) else { return }
        
        if quantity == 10 { return }
        CartManager.instance.updateQuantity(product: item, quantity: quantity + 1)
        shoppingCart = CartManager.instance.cart
        table.reloadData()
        refreshCart()
    }
    
    func didTapDelete(index: Int) {
        if shoppingCart!.products.count == 1 {
            CartManager.instance.emptyCart()
            dismiss(animated: true, completion: nil)
        } else {
            shoppingCart?.products.remove(at: index)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(shoppingCart) {
                UserDefaults.standard.set(encoded, forKey: "shoppingCart")
                CartManager.instance.cart = shoppingCart
                NotificationCenter.default.post(name: .cartDidChange, object: nil)
            }
            refreshCart()
        }
    }
    
    private func refreshCart() {
        var totalAccount: Float = 0.0
        for item in shoppingCart!.products {
            let price = NumberFormatter().number(from: item.price!) ?? 0.0
            let quantity = NumberFormatter().number(from: item.quantity!) ?? 0.0
            totalAccount += (price.floatValue * quantity.floatValue)
        }
        shoppingCart?.sub_amount = "\(totalAccount)"
        amount.text = "$\(totalAccount.clean)"
        let costInCoco = totalAccount * 1000
        cocopoints.text = "\(costInCoco.clean)"
        table.reloadData()
    }
}
