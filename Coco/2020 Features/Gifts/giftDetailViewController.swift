//
//  giftDetailViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 18/06/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit
import SkyFloatingLabelTextField

class giftDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var orderNameNUmber: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var store: UILabel!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var redeemGiftButton: UIButton!
    @IBOutlet weak var giftsTable: UITableView!
    @IBOutlet weak var mensajeDeAmigo: UILabel!
    @IBOutlet weak var especificaOrden: SkyFloatingLabelTextField!
    @IBOutlet weak var contentView: UIView!
    
    var player : AVPlayer?
    var orderNumber : String!
    let userID = UserManagement.shared.id_user
    var giftStatus : String?
    var loader: LoaderVC!
    var giftProducts : [Dictionary<String, Any>] = []
    let reuseDocument = "DocumentCell666"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTable()
        getGiftDetails()
        NotificationCenter.default.addObserver(self, selector: #selector(reveal), name: Notification.Name(rawValue: "revealTheView"), object: nil)
        //   initializeVideoPlayerWithVideo()
    }
    
    @objc func reveal() {
        self.contentView.alpha = 1
    }
    
    func configureTable() {
        giftsTable.delegate = self
        giftsTable.dataSource = self
        giftsTable.tableFooterView = UIView()
        let nib = UINib(nibName: "giftDetailImagesTableViewCell", bundle: nil)
        giftsTable.register(nib, forCellReuseIdentifier: reuseDocument )
        giftsTable.separatorStyle = .none
    }
    
    func configureView() {
        contentView.alpha = 0
        backgroundView.layer.masksToBounds = false
        backgroundView.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)
        backgroundView.layer.shadowRadius = 5
        backgroundView.layer.shadowOpacity = 0.5
        backgroundView.layer.cornerRadius = 12
        orderNameNUmber.roundCorners(12)
        redeemGiftButton.roundCorners(12)
        redeemGiftButton.isHidden = true
        especificaOrden.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 288
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        giftProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseDocument, for: indexPath) as? giftDetailImagesTableViewCell else {
            return UITableViewCell()
        }
        
        let document = giftProducts[indexPath.row]
        let nombredeProducto = document["nombre"] as! String
        let imagenDeProducto = document["imagen"] as! String
        
        cell.nameOfProduct.text = nombredeProducto
        cell.productImage.sd_setImage(with: URL(string: imagenDeProducto), completed: nil)
        
        return cell
    }
    
    //    func initializeVideoPlayerWithVideo() {
    //        videoPlayer.clipsToBounds = true
    //        let videoString:String? = Bundle.main.path(forResource: "gift", ofType: "mp4")
    //        guard let unwrappedVideoPath = videoString else {return}
    //        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
    //        self.player = AVPlayer(url: videoUrl)
    //        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
    //        layer.frame = videoPlayer!.bounds
    //        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    //        layer.cornerRadius = 30
    //        videoPlayer?.layer.addSublayer(layer)
    //    }
    
    func showingTheVideo(idNumber:String, statusRegalo: String) {
        DispatchQueue.main.async {
            let myViewController = animationPopUpViewController(nibName: "animationPopUpViewController", bundle: nil)
            if #available(iOS 13.0, *) {
                myViewController.isModalInPresentation = true
            } else {
                print("You are in iOS 12 or lower")
            }
            myViewController.orderNumber = idNumber
            myViewController.giftStatus = statusRegalo
            myViewController.modalPresentationStyle = .overCurrentContext
            self.present(myViewController, animated: false, completion: nil)
        }
    }
    
    func getGiftDetails() {
        showLoader(&loader, view: view)
        let url = URL(string: General.endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let string1 = "funcion=getPresentDetail&id_user="+userID!
        let string2 = "&id_order="+orderNumber
        let postString = string1+string2
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, response != nil else {
                return
            }
            let gift = try? JSONDecoder().decode(giftDetailMain.self, from: data)
            let productnameText = gift?.data?.products![0].nombre
            let imageProduct = gift?.data?.products![0].imagen
            
            //            DispatchQueue.main.async {
            //                self.productName.text = productnameText
            //                self.productImage.sd_setImage(with: URL(string: imageProduct!), completed: nil)
            //                self.openedGiftImage.sd_setImage(with: URL(string: imageProduct!), completed: nil)
            //            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            if let dictionary = json as? Dictionary<String, AnyObject> {
                if let items = dictionary["data"] {
                    if let info = items["info"] as? Dictionary<String, AnyObject>{
                        let orden = info["Id"] as! String
                        let fecha = info["fecha"] as! String
                        let status = info["estatus"] as! String
                        let cafeteria = info["nombre"] as! String
                        let amigo = info["alumno_regalo"] as! String
                        let mensajeAmigo = info["mensaje_amigo"] as! String
                        DispatchQueue.main.async {
                            self.orderNameNUmber.text = orden
                            self.date.text = "Fecha: " + fecha
                            self.status.text = "Estatus: " + status
                            self.store.text = "Cafetería: " + cafeteria
                            self.friendName.text = amigo
                            self.mensajeDeAmigo.text = mensajeAmigo
                            self.loader.removeAnimate()
                            if status == "Pagado" {
                                self.especificaOrden.isHidden = false
                                self.redeemGiftButton.isHidden = false
                            }
                        }
                        
                        if self.giftStatus == "Cerrado" {
                            self.showingTheVideo(idNumber: orden, statusRegalo: self.giftStatus!)
                        }
                        
                        if self.giftStatus == "Abierto" {
                            DispatchQueue.main.async {
                            self.contentView.alpha = 1
                            } 
                        }
                    }
                    
                    if let productos = items["products"] as? [Dictionary<String, Any>] {
                        for d in productos {
                            self.giftProducts.append(d)
                            print("Anotha one")
                            print(d)
                            print("And added")
                            print(self.giftProducts)
                        }
                    }
                }
                
            }
            DispatchQueue.main.async {
                self.giftsTable.reloadData()
            }
        }.resume()
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func redeemGift(_ sender: Any) {
        
        // Alert with action
        
        let alert = UIAlertController(title: "Canjeando", message: "¿De verdad quieres canjear el regalo?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Si", style: .destructive, handler: { action in
            
            let url = URL(string: General.endpoint)!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let string1 = "funcion=changePresent&id_user="+self.userID!
            let string2 = "&id_order="+self.orderNumber
            let orderSpecifics = self.especificaOrden.text ?? ""
            let string3 = "&comments="+orderSpecifics
            let postString = string1+string2+string3
            print(postString)
            request.httpBody = postString.data(using: .utf8)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil, response != nil else {
                    return
                }
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                if let dictionary = json as? Dictionary<String, AnyObject> {
                    
                    if let estimatedTime = dictionary["data"] as? Dictionary<String, AnyObject> {
                        if let time = estimatedTime["TiempoEstimado"] {
                            UserDefaults.standard.set(time, forKey: "estimatedValue")
                        }
                    }
                    
                    if let state = dictionary["state"] {
                        if state as! String == "200" {
                            NotificationCenter.default.post(name: Notification.Name("refreshTheList"), object: nil)
                            DispatchQueue.main.async {
                                UserDefaults.standard.set(false, forKey: "comingFromFriend")
                                // Register Nib
                                let newViewController = doneModalViewController(nibName: "doneModalViewController", bundle: nil)
                                newViewController.modalPresentationStyle = .fullScreen
                                // Present View "Modally"
                                self.present(newViewController, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }.resume()
            
        }))
        
        self.present(alert, animated: true)
        
    }
    
}

//extension giftDetailViewController : UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 288
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        giftProducts.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("Loaded")
//        let document = giftProducts[indexPath.row]
//        let nombredeProducto = document["nombre"] as! String
//        let imagenDeProducto = document["imagen"] as! String
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseDocument, for: indexPath)
//        if let cell = cell as? giftDetailImagesTableViewCell {
//            DispatchQueue.main.async {
//                cell.nameOfProduct.text = nombredeProducto
//                cell.productImage.sd_setImage(with: URL(string: imagenDeProducto), completed: nil)
//            }
//            return cell
//        }
//        return UITableViewCell()
//    }
//}
