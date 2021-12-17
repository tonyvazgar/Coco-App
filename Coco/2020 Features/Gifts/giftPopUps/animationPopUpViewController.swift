//
//  animationPopUpViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 23/06/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

class animationPopUpViewController: UIViewController {
    
    @IBOutlet weak var productsTable: UITableView!
    @IBOutlet weak var friendMessage: UILabel!
    @IBOutlet weak var okayButton: UIButton!
    @IBOutlet weak var videoPlayer: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var giftsImages : [Dictionary<String, Any>] = []
    let reuseDocument = "DocumentCell666"
    var loader: LoaderVC!
    let userID = UserManagement.shared.id_user
    var orderNumber : String!
    var giftStatus : String!
    var player : AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTable()
        getImages()
        initializeVideoPlayerWithVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        player?.play()
    }
    
    func configureTable() {
        productsTable.delegate = self
        productsTable.dataSource = self
        productsTable.tableFooterView = UIView()
        let nib = UINib(nibName: "productImagesTableViewCell", bundle: nil)
        productsTable.register(nib, forCellReuseIdentifier: reuseDocument )
        productsTable.separatorStyle = .none
    }
    
    func configureView() {
        DispatchQueue.main.async {
            self.okayButton.layer.cornerRadius = 12
            self.friendMessage.alpha = 0
            self.messageLabel.alpha = 0
            self.okayButton.alpha = 0
            self.productsTable.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 2, animations: {
                self.friendMessage.alpha = 1
                self.messageLabel.alpha = 1
                self.okayButton.alpha = 1
                self.productsTable.alpha = 1
                self.videoPlayer.alpha = 0
            })
        }
    }
    
    func initializeVideoPlayerWithVideo() {
        videoPlayer.clipsToBounds = true
        let videoString:String? = Bundle.main.path(forResource: "gift", ofType: "mp4")
        guard let unwrappedVideoPath = videoString else {return}
        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
        self.player = AVPlayer(url: videoUrl)
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.frame = videoPlayer!.bounds
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.cornerRadius = 30
        videoPlayer?.layer.addSublayer(layer)
    }
    
    func getImages() {
        showLoader(&loader, view: view)
        let url = URL(string: General.endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=getPresentDetail&id_user="+userID!+"&id_order="+orderNumber
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, response != nil else {
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            if let dictionary = json as? Dictionary<String, AnyObject> {
                if let items = dictionary["data"] {
                    
                    if let info = items["info"] as? Dictionary<String, AnyObject>{
                        let mensajeAmigo = info["mensaje_amigo"] as! String
                        DispatchQueue.main.async {
                            self.friendMessage.text = mensajeAmigo
                        }
                    }
                    
                    if let productos = items["products"] as? [Dictionary<String, Any>] {
                        for d in productos {
                            self.giftsImages.append(d)
                            print("Anotha one")
                            print(d)
                            print("And added")
                            print(self.giftsImages)
                        }
                    }
                }
                
            }
            DispatchQueue.main.async {
                self.productsTable.reloadData()
                self.loader.removeAnimate()
            }
        }.resume()
    }
    
    @IBAction func GotIt(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("revealTheView"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("refreshTheList"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("stopShaking"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}

extension animationPopUpViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        giftsImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseDocument, for: indexPath) as? productImagesTableViewCell else {
            return UITableViewCell()
        }
        
        let document = giftsImages[indexPath.row]
        let nombredeProducto = document["nombre"] as! String
        let imagenDeProducto = document["imagen"] as! String
        
        cell.productName.text = nombredeProducto
        cell.productImage.sd_setImage(with: URL(string: imagenDeProducto), completed: nil)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 288
    }
}
