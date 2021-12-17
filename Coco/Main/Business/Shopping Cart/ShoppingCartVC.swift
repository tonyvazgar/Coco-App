//
//  ShoppingCartVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/9/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import M13Checkbox
import DropDown
import SkyFloatingLabelTextField

class ShoppingCartVC: UIViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tip_5: UIButton!
    @IBOutlet weak var tip_10: UIButton!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tip_15: UIButton!
    @IBOutlet weak var orderDescription: UITextView!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var cocopoints: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var payWithMoneyButton: UIButton!
    @IBOutlet weak var payWithCocopoints: UIButton!
    @IBOutlet weak var payWithCocoButton: UIButton!
    @IBOutlet weak var payViews: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var cocoLabel: UILabel!
    @IBOutlet weak var noCheckView: UIView!
    @IBOutlet weak var yesCheckView: UIView!
    @IBOutlet weak var searchFriendView: UIView!
    @IBOutlet weak var disappearingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var giftOptionsView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var messageForFriend: UIView!
    @IBOutlet weak var messageForFriendTF: SkyFloatingLabelTextField!
    @IBOutlet weak var payButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cocoPayTopConstraing: NSLayoutConstraint!
    
    var loader: LoaderVC!
    var shoppingCart: ShoppingCart?
    var shoppingCart2extra: ShoppingCart2?
    private var mainData: Main!
    private var balance: String = ""
    private var cocopointsBalance: String = ""
    var costInCocopoints: String = ""
    var normalCost: String = ""
    let userID = UserManagement.shared.id_user
    var tip: Int = 0
    let checkYes = M13Checkbox()
    let checkNo = M13Checkbox()
    let dropdown = DropDown()
    var data: [String] = ["apple","appear","Azhar","code","BCom"]
    var dataFiltered: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.barTintColor = .white
        searchBar.tintColor = .black
        dataFiltered = data
        requestData()
        configureView()
        configureTable()
        getShoppingCart()
        firstTimer()
        configureDropdown()
        NotificationCenter.default.addObserver(self, selector: #selector(self.changedTheName), name: Notification.Name("changedTheName"), object: nil)
    }
    
    @objc func changedTheName() {
        let newName = UserDefaults.standard.value(forKey: "friendName") as! String
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                self.searchBar.placeholder = newName
            } else {
                self.searchBar.placeholder = newName
            }
        }
    }
    
    private func configureDropdown() {
        dropdown.anchorView = searchBar
        dropdown.bottomOffset = CGPoint(x: 0, y: searchBar.bounds.height)
        dropdown.direction = .bottom
        dropdown.dataSource = data
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Some value: \(item) in the index \(index)")
            self.dropdown.hide()
        }
    }
    
    private func configureTable() {
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        let nib = UINib(nibName: ShoppingCartProductCellTableViewCell.cellIdentifier, bundle: nil)
        table.register(nib, forCellReuseIdentifier: ShoppingCartProductCellTableViewCell.cellIdentifier)
    }
    
    private func getShoppingCart() {
        if let cart = UserDefaults.standard.data(forKey: "shoppingCart") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(ShoppingCart.self, from: cart) {
                shoppingCart = decoded
                businessName.text = shoppingCart?.store_name
                let value = Double("\(shoppingCart?.sub_amount ?? "")") ?? 0
                let oneThousand = 1000.0
                let valueCocopoints = value * oneThousand
                let textCocos = Float(valueCocopoints).clean
                
                normalCost = Float(value).clean
                amount.text = "$"+normalCost
                costInCocopoints = "\(valueCocopoints)"
                cocopoints.text = textCocos
            }
        }
    }
    
    private func requestData() {
        mainData = Main()
        mainData.requestUserMain { (result) in
            switch result {
            case .failure(let errorMssg):
                self.throwError(str: errorMssg)
            case .success(_):
                self.cocoLabel.text = "Cocopoints: \(self.mainData.info?.cocopoints_balance ?? "--")"
                self.balanceLabel.text = "Saldo: $\(self.mainData.info?.current_balance ?? "--")"
                self.balance = self.mainData.info?.current_balance ?? "0.0"
                self.cocopointsBalance = self.mainData.info?.cocopoints_balance ?? "0.0"
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadBalance"), object: nil)
            }
        }
    }
    
    private func configureView() {
        UserDefaults.standard.set(false, forKey: "toFriend")
        searchBar.delegate = self
        backView.setShadow()
        backView.roundCorners(15)
        payButton.roundCorners(15)
        tip_5.circleBorders()
        tip_10.circleBorders()
        tip_15.circleBorders()
        tip_5.addBorder(thickness: 2, color: .CocoBlack)
        tip_10.addBorder(thickness: 2, color: .CocoBlack)
        tip_15.addBorder(thickness: 2, color: .CocoBlack)
        orderDescription.addBorder(thickness: 1, color: .CocoBlack)
        payWithMoneyButton.roundCorners(15)
        payWithCocopoints.roundCorners(15)
        payWithCocoButton.roundCorners(15)
        balanceLabel.roundCorners(9)
        cocoLabel.roundCorners(9)
        disappearingViewHeight.constant = 0
        searchFriendView.isHidden = true
        
        noCheckView.addSubview(checkNo)
        checkNo.frame = CGRect(origin: .zero, size: noCheckView.frame.size)
        checkNo.setCheckState(.checked, animated: true)
        checkNo.tintColor = .white
        checkNo.backgroundColor = .CocoPink
        checkNo.boxType = .circle
        checkNo.checkmarkLineWidth = 3
        checkNo.layer.masksToBounds = true
        noCheckView.layer.cornerRadius = checkNo.bounds.height / 2
        checkNo.layer.cornerRadius = noCheckView.bounds.height / 2
        checkNo.addTarget(self, action: #selector(self.noCheckBoxPressed(_:)), for: .valueChanged)
        checkNo.stateChangeAnimation = .expand(.stroke)
        
        yesCheckView.addSubview(checkYes)
        checkYes.frame = CGRect(origin: .zero, size: yesCheckView.frame.size)
        checkYes.setCheckState(.unchecked, animated: true)
        checkYes.tintColor = .white
        checkYes.backgroundColor = .CocoPink
        checkYes.boxType = .circle
        checkYes.checkmarkLineWidth = 3
        checkYes.layer.masksToBounds = true
        yesCheckView.layer.cornerRadius = checkYes.bounds.height / 2
        checkYes.layer.cornerRadius = yesCheckView.bounds.height / 2
        checkYes.addTarget(self, action: #selector(self.yesCheckboxPressed(_:)), for: .valueChanged)
        checkYes.stateChangeAnimation = .expand(.stroke)
        
    }
    
    @objc func yesCheckboxPressed(_ sender: M13Checkbox) {
        UserDefaults.standard.set(true, forKey: "toFriend")
        UIView.animate(withDuration: 0.5, animations: {
            self.checkYes.isUserInteractionEnabled = false
            self.checkNo.isUserInteractionEnabled = true
            self.checkNo.setCheckState(.unchecked, animated: true)
            self.disappearingViewHeight.constant = 250
            self.searchFriendView.isHidden = false
            self.view.layoutIfNeeded()
            let bottomOffset = CGPoint(x: 0, y: self.mainScrollView.contentSize.height - self.mainScrollView.bounds.size.height)
            self.mainScrollView.setContentOffset(bottomOffset, animated: true)
        })
    }
    
    @objc func noCheckBoxPressed(_ sender: M13Checkbox){
        UserDefaults.standard.set(false, forKey: "toFriend")
        checkNo.isUserInteractionEnabled = false
        checkYes.isUserInteractionEnabled = true
        checkYes.setCheckState(.unchecked, animated: true)
        disappearingViewHeight.constant = 0
        searchFriendView.isHidden = true
        self.view.layoutIfNeeded()
    }
    
    func firstTimer() {
        tipLabel.isHidden = true
        tip_5.isHidden = true
        tip_10.isHidden = true
        tip_15.isHidden = true
        orderDescription.isHidden = true
        descriptionLabel.isHidden = true
        payButton.isHidden = true
        payWithCocoButton.isHidden = true
    }
    
    @IBAction func payWithMoney(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "toFriend") == true {
            descriptionLabel.isHidden = true
            orderDescription.isHidden = true
            tip_5.isHidden = true
            tip_10.isHidden = true
            tip_15.isHidden = true
            payButtonTopConstraint.constant = 23
            mainScrollView.scrollToTop()
            mainScrollView.isScrollEnabled = false
        }
        
        if UserDefaults.standard.bool(forKey: "toFriend") == false {
            descriptionLabel.isHidden = false
            orderDescription.isHidden = false
            tipLabel.isHidden = false
            tip_5.isHidden = false
            tip_10.isHidden = false
            tip_15.isHidden = false
        }
        payViews.isHidden = true
        payButton.isHidden = false
        giftOptionsView.isHidden = true
        //        let bottomOffset = CGPoint(x: 0, y: scroll.contentSize.height - scroll.bounds.size.height)
        //        scroll.setContentOffset(bottomOffset, animated: true)
        searchFriendView.isHidden = true
    }
    
    @IBAction func payWithCocopoints(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "toFriend") == true {
            descriptionLabel.isHidden = true
            orderDescription.isHidden = true
            cocoPayTopConstraing.constant = 23
            mainScrollView.scrollToTop()
         //   mainScrollView.isScrollEnabled = false
        }
        
        if UserDefaults.standard.bool(forKey: "toFriend") == false {
            descriptionLabel.isHidden = false
            orderDescription.isHidden = false
        }
        giftOptionsView.isHidden = true
        payViews.isHidden = true
        searchFriendView.isHidden = true
        payWithCocoButton.isHidden = false
//        let bottomOffset = CGPoint(x: 0, y: scroll.contentSize.height - scroll.bounds.size.height)
//        scroll.setContentOffset(bottomOffset, animated: true)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func payAction(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "toFriend") == true {
            guard let shoppingCart = shoppingCart else { return }
            shoppingCart.setService(percentage: tip)
            shoppingCart.comments = orderDescription.text
            guard let dict = try? shoppingCart.asDictionary() else {
                return
            }
            
            var jsonText = ""
            var products = [[String: Any]]()
            for i in dict["products"] as! [[String: Any]] {
                var temp = [String: Any]()
                temp["id"] = i["Id"]
                temp["cantidad"] = i["cantidad"]
                temp["precio"] = i["precio"]
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
            
            let idNumber = UserDefaults.standard.value(forKey: "friendID") as! String
            
            showLoader(&loader, view: view)
            shoppingCart.saveOrderGiftMoney(idFriend: idNumber, friendMessage: messageForFriendTF.text ?? "", products: jsonText, parameters: dict, completion: { result in
                self.loader.removeAnimate()
                switch result {
                case .failure(let errorMssg):
                    self.throwError(str: errorMssg)
                    return
                case .success(_):
                    UserDefaults.standard.set(true, forKey: "comingFromFriend")
                    UserDefaults.standard.removeObject(forKey: "shoppingCart")
                    // Register Nib
                    let newViewController = doneModalViewController(nibName: "doneModalViewController", bundle: nil)
                    newViewController.modalPresentationStyle = .fullScreen
                    
                    // Present View "Modally"
                    self.present(newViewController, animated: true, completion: nil)
                }
            })
        }
        
        if UserDefaults.standard.bool(forKey: "toFriend") == false {
            guard let shoppingCart = shoppingCart else { return }
            shoppingCart.setService(percentage: tip)
            shoppingCart.comments = orderDescription.text
            guard let dict = try? shoppingCart.asDictionary() else {
                return
            }
            
            var jsonText = ""
            var products = [[String: Any]]()
            for i in dict["products"] as! [[String: Any]] {
                var temp = [String: Any]()
                temp["id"] = i["Id"]
                temp["cantidad"] = i["cantidad"]
                temp["precio"] = i["precio"]
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
                    UserDefaults.standard.removeObject(forKey: "shoppingCart")
                    // Register Nib
                    let newViewController = doneModalViewController(nibName: "doneModalViewController", bundle: nil)
                    newViewController.modalPresentationStyle = .fullScreen
                    
                    // Present View "Modally"
                    self.present(newViewController, animated: true, completion: nil)
                }
            })
        }
        
    }
    
    @IBAction func payActionB(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "toFriend") == false {
            
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
                temp["precio"] = i["precio"]
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
            let comments = (shoppingCart?.comments)!
            
            let Parameters = [
                "funcion" : "saveOrderCocopoints",
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
                    
                    print("This /n is /n the /n jsonText")
                    print(jsonText)
                    print("********************")
                    
                    UserDefaults.standard.removeObject(forKey: "shoppingCart")
                    // Register Nib
                    let newViewController = doneModalViewController(nibName: "doneModalViewController", bundle: nil)
                    newViewController.modalPresentationStyle = .fullScreen
                    // Present View "Modally"
                    self.present(newViewController, animated: true, completion: nil)
                }
            })
            
        }
        
        if UserDefaults.standard.bool(forKey: "toFriend") == true {
            
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
                temp["precio"] = i["precio"]
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
            let comments = (shoppingCart?.comments)!
            
            let Parameters = [
                "funcion" : "saveOrderCocopointsPresent",
                "id_user" : UserManagement.shared.id_user!,
                "amount_final" : normalCost1,
                "amount_cocopoints": cost,
                "id_store" : idStore,
                "comments" : comments] as [String : Any]
            
            let idNumber = UserDefaults.standard.value(forKey: "friendID") as! String
            
            showLoader(&loader, view: view)
            shoppingCart!.saveOrderCocopointsGift(idFriend: idNumber, friendMessage: messageForFriendTF.text ?? "", products: jsonText, parameters: Parameters, completion: { result in
                self.loader.removeAnimate()
                switch result {
                case .failure(let errorMssg):
                    self.throwError(str: errorMssg)
                    return
                case .success(_):
                    UserDefaults.standard.removeObject(forKey: "shoppingCart")
                    UserDefaults.standard.set(true, forKey: "comingFromFriend")
                    // Register Nib
                    let newViewController = doneModalViewController(nibName: "doneModalViewController", bundle: nil)
                    newViewController.modalPresentationStyle = .fullScreen
                    // Present View "Modally"
                    self.present(newViewController, animated: true, completion: nil)
                }
            })
            
        }
        
    }
    
    @IBAction func tip5Action(_ sender: Any) {
        tip_5.backgroundColor = .CocoBlack
        tip_5.setTitleColor(.white, for: .normal)
        tip_10.backgroundColor = .clear
        tip_10.setTitleColor(.CocoBlack, for: .normal)
        tip_15.backgroundColor = .clear
        tip_15.setTitleColor(.CocoBlack, for: .normal)
        tip = 5
    }
    
    @IBAction func tip10Action(_ sender: Any) {
        tip_5.backgroundColor = .clear
        tip_5.setTitleColor(.CocoBlack, for: .normal)
        tip_10.backgroundColor = .CocoBlack
        tip_10.setTitleColor(.white, for: .normal)
        tip_15.backgroundColor = .clear
        tip_15.setTitleColor(.CocoBlack, for: .normal)
        tip = 10
    }
    
    @IBAction func tip15Action(_ sender: Any) {
        tip_5.backgroundColor = .clear
        tip_5.setTitleColor(.CocoBlack, for: .normal)
        tip_10.backgroundColor = .clear
        tip_10.setTitleColor(.CocoBlack, for: .normal)
        tip_15.backgroundColor = .CocoBlack
        tip_15.setTitleColor(.white, for: .normal)
        tip = 15
    }
    @IBAction func showList(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "listOfStudentsViewController") as! listOfStudentsViewController
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(destVC, animated: true, completion: nil)
    }
    
}

extension ShoppingCartVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingCart?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingCartProductCellTableViewCell.cellIdentifier, for: indexPath) as? ShoppingCartProductCellTableViewCell else {
            return UITableViewCell()
        }
        
        if let item = shoppingCart?.products[indexPath.row] {
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
            cell.delegate = self
            cell.index = indexPath.row
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ShoppingCartVC: ShoppingCartProductCellDelegate {
    func didTapDelete(index: Int) {
        if shoppingCart!.products.count == 1 {
            UserDefaults.standard.removeObject(forKey: "shoppingCart")
            dismiss(animated: true, completion: nil)
        } else {
            shoppingCart?.products.remove(at: index)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(shoppingCart) {
                UserDefaults.standard.set(encoded, forKey: "shoppingCart")
                CartManager.instance.cart = shoppingCart
                NotificationCenter.default.post(name: .cartDidChange, object: nil)
            }
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
}

extension ShoppingCartVC : UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("Alright")
        print("Bitches")
        dropdown.dataSource = ["apple","appear","Azhar","code","BCom"]
        dropdown.show()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataFiltered = searchText.isEmpty ? data : data.filter({ (dat) -> Bool in
            dat.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        dropdown.dataSource = dataFiltered
        dropdown.show()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        for ob: UIView in ((searchBar.subviews[0] )).subviews {
            if let z = ob as? UIButton {
                let btn: UIButton = z
                btn.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        dataFiltered = data
        dropdown.hide()
    }
    
}

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
    
    func scrollToBottom() {
        let desiredOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(desiredOffset, animated: true)
    }
}
