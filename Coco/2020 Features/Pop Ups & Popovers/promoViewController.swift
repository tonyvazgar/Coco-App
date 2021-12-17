//
//  promoViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 21/05/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import SDWebImage

class promoViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var promoImage: UIImageView!
    @IBOutlet weak var iWantItButton: UIButton!
    @IBOutlet weak var closePromoButton: UIButton!
    
    var userProfile: UserProfile!
    var user: User!
    let userID = UserManagement.shared.id_user
    var urlToVisit : String?
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requesData()
        setupView()
    }
    
    //MARK: Funcs
    
    func setupView () {
        promoImage.layer.cornerRadius = 23
        iWantItButton.layer.cornerRadius = 23
        DispatchQueue.main.async {
            self.mainView.alpha = 0
            self.promoImage.alpha = 0
            self.iWantItButton.alpha = 0
        }
    }
    
    func showPromo () {
        UIView.animate(withDuration: 2, animations: {
            DispatchQueue.main.async {
                self.mainView.alpha = 1
                self.promoImage.alpha = 1
                self.iWantItButton.alpha = 1
            }
        })
    }
    
    private func requesData() {
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
            let imageURL = promoInfo.data?.promocion?.imagen
            let URLDirection = promoInfo.data?.promocion?.link
            let str = imageURL?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            self.urlToVisit = URLDirection
            self.promoImage.sd_setImage(with: URL(string: str! ), completed: nil)
            DispatchQueue.main.async {
                self.showPromo()
            }
        }
        task.resume()
    }
    
    // MARK: Actions
    
    @IBAction func goToProm(_ sender: Any) {
        if let url = URL(string: urlToVisit ?? "www.google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
