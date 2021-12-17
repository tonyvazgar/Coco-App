//
//  MainController.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import SnapKit
import Hero

class MainController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var cocopointsView: UIView!
    @IBOutlet weak var cocopointsBalance: UILabel!
    @IBOutlet weak var currentEstimatedTime: UIView!
    @IBOutlet weak var estimatedTimeText: UILabel!
    @IBOutlet weak var giftButton: UIButton!
    
    private var loader: LoaderVC!
    private var mainData: Main!
    let userID = UserManagement.shared.id_user
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainData = Main()
        configureView()
        configureTable()
        getGiftState()
        let pushManager = PushNotificationManager()
        pushManager.registerForPushNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: Notification.Name(rawValue: "reloadBalance"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPopUp), name: Notification.Name(rawValue: "showPopUp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopShaking), name: Notification.Name(rawValue: "stopShaking"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getGiftState2), name: Notification.Name(rawValue: "anotherGift"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestEstimatedTime2), name: Notification.Name(rawValue: "getMoreTime"), object: nil)
    }
    
    func gotCocos() {
        if UserDefaults.standard.bool(forKey: "gotCocos") == true {
            print("product bought with cocopoints")
            addedCocopoints()
        }
    }
    
    @objc func stopShaking() {
        giftButton.layer.removeAllAnimations()
    }
    
    func addedCocopoints() {
        UserDefaults.standard.set(false, forKey: "showedPromo")
        DispatchQueue.main.async {
            let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popoverID")
            popController.modalPresentationStyle = .overCurrentContext
            popController.modalPresentationStyle = .popover
            popController.modalTransitionStyle = .crossDissolve
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            popController.popoverPresentationController?.delegate = self
            popController.popoverPresentationController?.sourceView = self.cocopointsView
            popController.popoverPresentationController?.sourceRect = CGRect(x: 40, y: 0, width: 75, height: 35)
            popController.preferredContentSize = CGSize(width: 75, height: 35)
            self.present(popController, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if UserDefaults.standard.bool(forKey: "showedPromo") == true {
//            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//            let destVC = storyboard.instantiateViewController(withIdentifier: "promoViewController") as! promoViewController
//            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//            UserDefaults.standard.set(false, forKey: "showedPromo")
//            self.present(destVC, animated: true, completion: nil)
//        }
//        if UserDefaults.standard.bool(forKey: "gotCocos") == true {
//            addedCocopoints()
//        }
//        requestEstimatedTime()
    }
    
    @objc func showPopUp() {
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let destVC = storyboard.instantiateViewController(withIdentifier: "promoViewController") as! promoViewController
//        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        UserDefaults.standard.set(false, forKey: "showedPromo")
//        self.present(destVC, animated: true, completion: nil)
    }
    
    @objc func getGiftState2() {
        print("Called")
        let url = URL(string: General.endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=getUserMain&id_user="+userID!
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("error: No data to decode")
                return
            }
            guard let promoInfo = try? JSONDecoder().decode(Promo.self, from: data) else {
                print("Error: Couldn't decode data into info")
                return
            }
            
            if promoInfo.data?.promocion?.imagen == nil {
                DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: nil)
                }
                return
            }
            
            if promoInfo.data?.regalo != nil {
                DispatchQueue.main.async {
                    self.giftButton.shake(duration: 1, values: [-6.0, 6.0, -3.0, 3.0, -6.0, 6.0, -2.0, 2.0])
                }
            }
        }
        task.resume()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle { return UIModalPresentationStyle.none
    }
    
    func getGiftState() {
        let url = URL(string: General.endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=getUserMain&id_user="+userID!
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("error: No data to decode")
                return
            }
            guard let promoInfo = try? JSONDecoder().decode(Promo.self, from: data) else {
                print("Error: Couldn't decode data into info")
                return
            }
            
            if promoInfo.data?.promocion?.imagen == nil {
                DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: nil)
                }
                return
            }
            
            if promoInfo.data?.regalo != nil {
                DispatchQueue.main.async {
                    self.giftButton.shake(duration: 1, values: [-6.0, 6.0, -3.0, 3.0, -6.0, 6.0, -2.0, 2.0])
                }
            }
        }
        task.resume()
    }
    
    @objc func requestEstimatedTime2() {
        let url = URL(string: General.endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=getUserMain&id_user="+userID!
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
            if let dictionary = json as? Dictionary<String, AnyObject> {
                if let data = dictionary["data"] {
                    if let tiempoEstimado = data["ultimo_pedido"] {
                        let tiempoDePedido = "\(tiempoEstimado ?? 0)"
                        let tiempoDePedidoInt = Int(tiempoDePedido)
                        if tiempoDePedidoInt == nil {
                            DispatchQueue.main.async {
                                self.currentEstimatedTime.isHidden = true
                            }
                            return
                        }
                        if tiempoDePedidoInt == 0 {
                            self.currentEstimatedTime.isHidden = true
                        } else {
                            DispatchQueue.main.async {
                                let tiempoDePedidoMasUno = (tiempoDePedidoInt?.msToSeconds.minute)! + 1
                                self.estimatedTimeText.text = "\(tiempoDePedidoMasUno) Minutos"
                                self.currentEstimatedTime.isHidden = false
                                self.currentEstimatedTime.slideInFromBottom()
                                self.countDownTest(minutes: tiempoDePedidoMasUno, seconds: tiempoDePedidoInt?.msToSeconds.second ?? 0)
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        task.resume()
    }
    
    func requestEstimatedTime() {
        let url = URL(string: General.endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=getUserMain&id_user="+userID!
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
            if let dictionary = json as? Dictionary<String, AnyObject> {
                if let data = dictionary["data"] {
                    if let tiempoEstimado = data["ultimo_pedido"] {
                        let tiempoDePedido = "\(tiempoEstimado ?? 0)"
                        let tiempoDePedidoInt = Int(tiempoDePedido)
                        if tiempoDePedidoInt == nil {
                            DispatchQueue.main.async {
                                self.currentEstimatedTime.isHidden = true
                            }
                            return
                        }
                        if tiempoDePedidoInt == 0 {
                            self.currentEstimatedTime.isHidden = true
                        } else {
                            DispatchQueue.main.async {
                                let tiempoDePedidoMasUno = (tiempoDePedidoInt?.msToSeconds.minute)! + 1
                                self.estimatedTimeText.text = "\(tiempoDePedidoMasUno) Minutos"
                                self.currentEstimatedTime.isHidden = false
                                self.currentEstimatedTime.slideInFromBottom()
                                self.countDownTest(minutes: tiempoDePedidoMasUno, seconds: tiempoDePedidoInt?.msToSeconds.second ?? 0)
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        task.resume()
    }
    
    func countDownTest(minutes: Int, seconds: Int) {
        var minutesToGo = minutes
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { timer in
            self.estimatedTimeText.text = "\(minutesToGo) Minutos"
            minutesToGo -= 1
            if minutesToGo == 0 {
                DispatchQueue.main.async {
                    self.currentEstimatedTime.isHidden = true
                }
                timer.invalidate()
            }
            if minutesToGo == 1 {
                DispatchQueue.main.async {
                    self.currentEstimatedTime.isHidden = true
                }
                timer.invalidate()
            }
        }
    }
    
    @objc func shareTheCode() {
        let text = "¡Descarga Cocoapp y usa mi código para obtener saldo gratis en tu primera recarga! CODIGO: \(mainData.info?.codigo_referido ?? "--") Descargala en: https://apps.apple.com/mx/app/coco-app/id1470991257?l=en"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func didAddCode() {
        print("Labels Updated")
        mainData = Main()
        configureView()
        configureTable()
    }
    
    @objc func updateLabels() {
        mainData.requestUserMain { (result) in
            self.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self.throwError(str: errorMssg)
            case .success(_):
                self.table.reloadData()
                DispatchQueue.main.async {
                    self.balanceLabel.text = "Saldo: $\(self.mainData.info?.current_balance ?? "--")"
                    self.cocopointsBalance.text = "Cocopoints: \(self.mainData.info?.cocopoints_balance ?? "--")"
                }
                self.table.reloadData()
            }
        }
    }
    
    @IBAction func showCards(_ sender: Any) {
        let vc = BalanceVC()
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        presentAsync(vc)
    }
    
    @IBAction func showMeTheGifts(_ sender: Any) {
        giftButton.layer.removeAllAnimations()
        let myViewController = giftsViewController(nibName: "giftsViewController", bundle: nil)
        self.present(myViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func codigos(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "newCodeViewController") as! newCodeViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func showCocoPopUp(_ sender: UIButton) {
        if sender.tag == 1 {
            UserDefaults.standard.set("Cocopoints", forKey: "buttonPressed")
        }
        if sender.tag == 3 {
            UserDefaults.standard.set("tuCodigo", forKey: "buttonPressed")
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "popUpViewController") as! popUpViewController
        newViewController.modalPresentationStyle = .overCurrentContext
        newViewController.modalTransitionStyle = .crossDissolve
        newViewController.referalCode = mainData.info?.codigo_referido
        self.present(newViewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    
    private func configureView() {
        balanceView.roundCorners(15)
        cocopointsView.roundCorners(15)
        currentEstimatedTime.roundCorners(20)
        currentEstimatedTime.isHidden = true
        logo.slideInFromLeft()
    }
    
    private func configureTable() {
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        let nib = UINib(nibName: BusinessTableViewCell.cellIdentifier, bundle: nil)
        table.register(nib, forCellReuseIdentifier: BusinessTableViewCell.cellIdentifier)
        table.separatorStyle = .none
    }
    
    func requestData() {
        showLoader(&loader, view: view)
        mainData.requestUserMain { (result) in
            self.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self.throwError(str: errorMssg)
            case .success(_):
                print(result)
                self.fillInfo()
            }
        }
    }
    
    func fillInfo() {
        table.reloadData()
        balanceLabel.text = "Saldo: $ \(mainData.info?.current_balance ?? "--")"
        cocopointsBalance.text = "Cocopoints: \(mainData.info?.cocopoints_balance ?? "--")"
    }
    
    @IBAction func menuAction(_ sender: Any) {
        let vc = UIStoryboard.main.instantiate(MenuVC.self)
        vc.delegate = self
        addChild(vc)
        let username = "\(mainData.info?.name ?? "") \(mainData.info?.last_name ?? "")"
        vc.showInView(aView: view, userName: username)
    }
}

extension MainController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainData.stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BusinessTableViewCell.cellIdentifier, for: indexPath) as? BusinessTableViewCell else {
            return UITableViewCell()
        }
        
        let item = mainData.stores[indexPath.row]
        cell.businessName.text = item.name
        cell.businessSchedule.text = item.schedule
        cell.businessAddress.text = item.address
        cell.businessImage.kf.setImage(with: URL(string: item.imgURL ?? ""),
                                       placeholder: nil,
                                       options: [.transition(.fade(0.4))],
                                       progressBlock: nil,
                                       completionHandler: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = mainData.stores[indexPath.row]
        let vc = CategoriesVC()
        vc.modalPresentationStyle = .fullScreen
        vc.id_business = item.id ?? ""
        presentAsync(vc)
    }
}

extension MainController: MenuDelegate {
    func didSelectMenuOption(option: Menu) {
        switch option {
        case .profile:
            let vc = ProfileVC()
            vc.modalTransitionStyle = .crossDissolve
            presentAsync(vc)
        case .balance:
            let vc = BalanceVC()
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            presentAsync(vc)
        case .cocopoints:
            let addCardVC = storedCardsViewController(nibName: "storedCardsViewController", bundle: nil)
            self.present(addCardVC, animated: true, completion: nil)
        case .promocode:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "newCodeViewController") as! newCodeViewController
            self.present(newViewController, animated: true, completion: nil)
        case .favorite:
            let vc = FavoritesVC()
            vc.modalTransitionStyle = .crossDissolve
            presentAsync(vc)
        case .orders:
            let vc = OrdersVC()
            presentAsync(vc)
        case .settings:
            let vc = SettingsVC()
            presentAsync(vc)
        case .session:
            let refreshAlert = UIAlertController(title: "¿Cerrar sesión?", message: "Si cierras sesión tendrás que volver a introducir tus credenciales.", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Cerrar Sesión", style: .destructive, handler: { (action: UIAlertAction!) in
                UserDefaults.standard.removeObject(forKey: "id_user")
                UserDefaults.standard.removeObject(forKey: "email_user")
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.removeObject(forKey: "token_saved")
                //  Estas ultimas las tuve que borrar porque tengo que guardar algunos objetos para el inicio de sesión con Apple ID. No sé si sean necesarias despues.
                //  let domain = Bundle.main.bundleIdentifier!
                //  UserDefaults.standard.removePersistentDomain(forName: domain)
                //  UserDefaults.standard.synchronize()
                //  print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
                let vc = self.instantiate(viewControllerClass: AccountVC.self)
                let wnd = UIApplication.shared.keyWindow
                var options = UIWindow.TransitionOptions()
                options.direction = .toBottom
                options.duration = 0.4
                options.style = .easeOut
                wnd?.setRootViewController(vc, options: options)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                refreshAlert.dismiss(animated: true, completion: nil)
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }
    }
}

extension MainController: BalanceDelegate {
    func didChangeBalance() {
        requestData()
    }
}

extension UIView {
    
    // Using CAMediaTimingFunction
    func shake(duration: TimeInterval = 0.5, values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        
        // Swift 4.2 and above
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        animation.duration = duration // You can set fix duration
        animation.values = values  // You can set fix values here also
        animation.repeatDuration = .infinity
        self.layer.add(animation, forKey: "shake")
    }
    
    // Using SpringWithDamping
    func shake(duration: TimeInterval = 0.5, xValue: CGFloat = 12, yValue: CGFloat = 0) {
        self.transform = CGAffineTransform(translationX: xValue, y: yValue)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    // Using CABasicAnimation
    func shake(duration: TimeInterval = 0.05, shakeCount: Float = 6, xValue: CGFloat = 12, yValue: CGFloat = 0){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = shakeCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - xValue, y: self.center.y - yValue))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + xValue, y: self.center.y - yValue))
        self.layer.add(animation, forKey: "shake")
    }
    
}
