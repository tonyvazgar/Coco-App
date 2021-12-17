//
//  doneModalViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 06/02/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import AVKit
import Lottie

class doneModalViewController: UIViewController {
    weak var parentView: UIViewController?
    
    @IBOutlet weak var doneCheckVideo: UIView!
    @IBOutlet weak var doneText: UILabel!
    
    private var loaderAnimation: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVideoPlayerWithVideo()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            guard let navController = self.parentView?.navigationController else {
                let vc = UIStoryboard.tabBar.instantiate(MainTabBarController.self)
                let wnd = UIApplication.shared.keyWindow
                var options = UIWindow.TransitionOptions()
                options.direction = .fade
                options.duration = 0.4
                options.style = .easeOut
                wnd?.setRootViewController(vc, options: options)
                return
            }
            navController.popToRootViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        
        if let time = UserDefaults.standard.string(forKey: "estimatedValue") {
            doneText.text = "Tu pedido ha sido enviado y estará listo en \(time) minutos"
        } else {
            let time = UserDefaults.standard.integer(forKey: "estimatedValue")
            if time != 0 {
                doneText.text = "Tu pedido ha sido enviado y estará listo en \(time) minutos"
            } else {
                doneText.text = "Tu pedido ha sido enviado y estará listo en unos minutos"
            }
        }
    }
    
    func initializeVideoPlayerWithVideo() {
        doneCheckVideo.clipsToBounds = true
        
        loaderAnimation = AnimationView(name: "4964-check-mark-success-animation")
        loaderAnimation.frame = CGRect(origin: .zero, size: doneCheckVideo.frame.size)
        loaderAnimation.backgroundColor = .clear
        loaderAnimation.loopMode = .playOnce
        loaderAnimation.animationSpeed = 0.5
        doneCheckVideo.addSubview(loaderAnimation)
        
        loaderAnimation.play()
        
//        let videoString:String? = Bundle.main.path(forResource: "checkmark", ofType: "mp4")
//        guard let unwrappedVideoPath = videoString else {return}
//        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
//        self.player = AVPlayer(url: videoUrl)
//        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
//        layer.frame = doneCheckVideo!.bounds
//        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        layer.cornerRadius = 30
//        doneCheckVideo?.layer.addSublayer(layer)
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
