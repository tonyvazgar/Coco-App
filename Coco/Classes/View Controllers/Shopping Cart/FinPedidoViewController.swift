//
//  FinPedidoViewController.swift
//  Coco
//
//  Created by Erick Monfil on 01/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit
import Lottie
class FinPedidoViewController: UIViewController {
    weak var parentView: UIViewController?
    
    @IBOutlet weak var doneCheckVideo: UIView!
    private var loaderAnimation: AnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Constatns.LocalData.canasta = nil
        initializeVideoPlayerWithVideo()
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            guard let navController = self.parentView?.navigationController else {
                let vc = UIStoryboard.tabBar.instantiate(MainTabBarController.self)
                vc.selectedIndex = 2
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
    }
    
    func initializeVideoPlayerWithVideo() {
        doneCheckVideo.clipsToBounds = true
        
        loaderAnimation = AnimationView(name: "lf30_editor_xv20qsja")
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

}
