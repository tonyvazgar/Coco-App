//
//  SettingsViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/18/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    @IBOutlet private var notificationsView: UIView!
    @IBOutlet private var termsView: UIView!
    @IBOutlet private var privacyView: UIView!
    @IBOutlet private var versionView: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet private var notificationSwitch: UISwitch!
    
    private lazy var myFunction: Void = {
        notificationSwitch.isOn = true
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
            
            print("granted")
            UserDefaults.standard.set(true, forKey: "switchState")
            
        } else {
            
            print("not granted")
            UserDefaults.standard.set(false, forKey: "switchState")
            
        }
        
        _ = myFunction
        
        if UserDefaults.standard.bool(forKey: "switchState") == true {
            
            notificationSwitch.setOn(true, animated: true)
            
        } else {
            
            notificationSwitch.setOn(false, animated: true)
            
        }
        
    }
    
    private func configureView() {
        notificationsView.addBottomBorder(thickness: 1, color: .CocoBlack)
        termsView.addBottomBorder(thickness: 1, color: .CocoBlack)
        privacyView.addBottomBorder(thickness: 1, color: .CocoBlack)
        versionView.addBottomBorder(thickness: 1, color: .CocoBlack)
        
        versionLabel.text = "Versión \(UIApplication.versionBuild())"
    }
    
    @IBAction private func facebookBtn(_ sender: Any) {
        guard let url = URL(string: "https://www.facebook.com/Coco-App-105617244133298") else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    @IBAction private func instagramBtn(_ sender: Any) {
        guard let url = URL(string: "https://instagram.com/cocoappmx") else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    @IBAction private func privacyButton(_ sender: Any) {
        guard let url = URL(string: "http://cocosinfilas.com/TandC.pdf") else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    @IBAction private func termsButton(_ sender: Any) {
        guard let url = URL(string: "http://cocosinfilas.com/TandC.pdf") else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    @IBAction private func switchNotifications(_ sender: Any) {
        if notificationSwitch.isOn {
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    
    
    @IBAction private func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension UIApplication {
    struct Constants {
        static let CFBundleShortVersionString = "CFBundleShortVersionString"
    }
    class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: Constants.CFBundleShortVersionString) as! String
    }
  
    class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
  
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
      
        return version == build ? "\(version)" : "\(version)(\(build))"
    }
}
