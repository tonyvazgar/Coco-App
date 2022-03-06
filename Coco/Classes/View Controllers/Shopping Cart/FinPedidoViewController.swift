//
//  FinPedidoViewController.swift
//  Coco
//
//  Created by Erick Monfil on 01/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class FinPedidoViewController: UIViewController {
    weak var parentView: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        Constatns.LocalData.canasta = nil
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
    


}
