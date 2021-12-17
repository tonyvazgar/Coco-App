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
    }
    
    @IBAction private func facebookBtn(_ sender: Any) {
        guard let url = URL(string: "https://m.facebook.com/Cocoapp-547601782438531/?ref=bookmarks") else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    @IBAction private func instagramBtn(_ sender: Any) {
        guard let url = URL(string: "https://www.instagram.com/coco_appha/") else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    @IBAction private func privacyButton(_ sender: Any) {
        guard let url = URL(string: "http://easycode.mx/sistema_coco/aviso/politicas.pdf") else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    @IBAction private func termsButton(_ sender: Any) {
        guard let url = URL(string: "http://easycode.mx/sistema_coco/aviso/terminos.pdf") else {
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
