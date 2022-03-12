//
//  EncuestaSuccessViewController.swift
//  Coco
//
//  Created by Erick Monfil on 09/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit
import Lottie

class EncuestaSuccessViewController: UIViewController {
    weak var parentView: UIViewController?
    @IBOutlet weak var doneCheckVideo: UIView!
    private var loaderAnimation: AnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        loaderAnimation = AnimationView(name: "like")
        loaderAnimation.frame = CGRect(origin: .zero, size: doneCheckVideo.frame.size)
        loaderAnimation.backgroundColor = .clear
        loaderAnimation.loopMode = .playOnce
        loaderAnimation.animationSpeed = 0.5
        doneCheckVideo.addSubview(loaderAnimation)
        
        loaderAnimation.play()
        
    }
   
}
