//
//  BannerViewController.swift
//  Coco
//
//  Created by Tony Vazgar on 22/01/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import Foundation
import UIKit

class BannerViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var saltarButtonOutlet: UIButton!
    
    var contentWidth: CGFloat = 0.0
    
    var movies: [String] = ["Banner-1", "Banner-2", "Banner-3"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0
    
    @IBAction func saltarButtonAction(_ sender: Any) {
        let initialViewController: UIViewController
        if let _ = UserManagement.shared.id_user {
            initialViewController = UIStoryboard.tabBar.instantiate(MainTabBarController.self)
        } else {
            initialViewController = UIStoryboard.accounts.instantiate(SignInViewController.self)
        }
          
        let navigationController = UINavigationController(rootViewController: initialViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(navigationController.view)
        self.addChild(navigationController)
        navigationController.didMove(toParent: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.delegate = self
        pageControl.numberOfPages = movies.count
        saltarButtonOutlet.isHidden = true
        setUpImages()
    }
    
    func setUpImages() {
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
        for index in 0..<movies.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: movies[index])
            imgView.contentMode = .scaleToFill
            
            self.scrollView.addSubview(imgView)
        }
        scrollView.contentSize = CGSize(width: (scrollWidth * CGFloat(movies.count)), height: scrollHeight)
        self.scrollView.contentSize.height = 1.0
        scrollView.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
        
        if(Int(pageNumber) == 2){
            saltarButtonOutlet.isHidden = false
        }else{
            saltarButtonOutlet.isHidden = true
        }
    }
}

