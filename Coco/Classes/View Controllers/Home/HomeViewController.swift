//
//  HomeViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/7/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import SnapKit
import Hero
import Firebase
import FBSDKCoreKit

final class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate, SideMenuDelegate {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var cocopointsView: UIView!
    @IBOutlet weak var cocopointsBalance: UILabel!
    @IBOutlet weak var currentEstimatedTime: UIView!
    @IBOutlet weak var estimatedTimeText: UILabel!
    @IBOutlet weak var giftButton: UIButton!
    
    
    @IBOutlet private var locationView: UIView!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var contentView: UIView!
    
    private var loader: LoaderVC!
    private var mainData: Main!
    let userID = UserManagement.shared.id_user
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        let id = UserManagement.shared.id_user ?? ""
        
        if id != "" {
            requestInitialData()
        }
        
        mainData = Main()
//        getGiftState()
        AppEvents.logEvent(.viewedContent)
        let pushManager = PushNotificationManager()
        pushManager.registerForPushNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabels), name: Notification.Name(rawValue: "reloadBalance"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(showPopUp), name: Notification.Name(rawValue: "showPopUp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopShaking), name: Notification.Name(rawValue: "stopShaking"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(getGiftState2), name: Notification.Name(rawValue: "anotherGift"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(requestEstimatedTime2), name: Notification.Name(rawValue: "getMoreTime"), object: nil)
        
        LocationManager.shared.requestLocation { [weak self] _ in
            self?.configureTableView()
        }
       
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
    
    func countDownTest(minutes: Int, seconds: Int) {
        var minutesRemaining = minutes
        var secondsRemaining = seconds
        Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { [weak self] timer in
            if secondsRemaining < 6 {
                secondsRemaining = (60 + secondsRemaining) - 6
                minutesRemaining -= 1
                if minutesRemaining <= 0 {
                    self?.currentEstimatedTime.isHidden = true
                    timer.invalidate()
                } else {
                    self?.estimatedTimeText.text = "\(minutesRemaining) Minutos"
                }
            } else {
                secondsRemaining -= 6
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
    }
    
    @objc func updateLabels() {
        mainData.requestUserMain { (result) in
            self.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self.throwError(str: errorMssg)
            case .success(_):
                DispatchQueue.main.async {
                    self.balanceLabel.text = "Saldo: $\(self.mainData.info?.current_balance ?? "--")"
                    self.cocopointsBalance.text = "Cocopoints: \(self.mainData.info?.cocopoints_balance ?? "--")"
                }
            }
        }
    }
    
    @IBAction func showCards(_ sender: Any) {
        tabBarController?.selectedIndex = 3
//        let vc = BalanceVC()
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        presentAsync(vc)
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
        newViewController.modalPresentationStyle = .overFullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        newViewController.referalCode = mainData.info?.codigo_referido
        self.present(newViewController, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction private func menuAction(_ sender: Any) {
        let id = UserManagement.shared.id_user ?? ""
        if id == "" {
            self.sessionEnd()
        }
        else {
            let vc = UIStoryboard.sideMenu.instantiate(SideMenuViewController.self)
            vc.delegate = self
            addChild(vc)
            vc.showInView(aView: view)
        }
        
    }
}
// MARK: - Initial setup

private extension HomeViewController {
    func requestInitialData() {
        showLoader(&loader, view: view)
        HomeFetcher.fetchMain { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error):
                self?.throwError(str: error.localizedDescription)
            case .success(let data):
                DispatchQueue.main.async {
                    self?.populateContent(with: data)
                }
            }
        }
    }
    
    func populateContent(with data: HomeSetupDataModel) {
        UserManagement.shared.user = data.info
        balanceLabel.text = "Saldo: \n$ \(data.info?.current_balance ?? "--")"
        cocopointsBalance.text = "Cocopoints: \n\(data.info?.cocopoints_balance ?? "--")"
        
        /*
        if let lastOrder = data.ultimo_pedido, let orderTiming = Int(lastOrder) {
            let minutes = orderTiming.msToSeconds.minute + 1
            let seconds = orderTiming.msToSeconds.second
            currentEstimatedTime.isHidden = false
            currentEstimatedTime.slideInFromBottom()
            estimatedTimeText.text = "\(minutes) Minutos"
            countDownTest(minutes: minutes, seconds: seconds)
        }
        */
        guard let user = data.info else { return }
        let name = (user.name ?? "") + " " + (user.last_name ?? "")
        userNameLabel.text = name
    }
    
    func configureView() {
        balanceView.roundCorners(15)
        cocopointsView.roundCorners(15)
        currentEstimatedTime.roundCorners(20)
        currentEstimatedTime.isHidden = true
        logo.slideInFromLeft()
        
        // Location View
        locationView.layer.cornerRadius = 8
        locationView.layer.borderWidth = 0.5
        locationView.layer.borderColor = UIColor.lightGray.cgColor
        locationView.layer.shadowColor = UIColor.black.cgColor
        locationView.layer.shadowOffset = .zero
        locationView.layer.shadowOpacity = 0.25
        locationView.layer.shadowRadius = 2
        
        balanceView.isHidden = true
        cocopointsView.isHidden = true
        
        locationView.addTap(#selector(openCityUpdate), tapHandler: self)
    }
    
    @objc private func openCityUpdate() {
        let cityUpdate = CityUpdateViewController()
        addChild(cityUpdate)
        cityUpdate.showInView(view)
    }
    
    func configureTableView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 32, bottom: 0, right: 32)
        flowLayout.itemSize = CGSize(width: 140, height: 150)
        let businessesList = BusinessesListViewController(collectionViewLayout: flowLayout)
        businessesList.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(businessesList.view)
        addChild(businessesList)
        NSLayoutConstraint.activate([
            businessesList.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            businessesList.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            businessesList.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            businessesList.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

extension HomeViewController: BalanceDelegate {
    func didChangeBalance() {
//        requestData()
    }
}
