//
//  HelpViewController.swift
//  Coco
//
//  Created by Carlos Banos on 11/9/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class HelpViewController: UIViewController {
    
    @IBOutlet private var backView: UIView!
    @IBOutlet private var callButton: UIButton!
    @IBOutlet private var sendMessageButton: UIButton!
    
    let phoneNumber = "522227092374"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    @IBAction private func closeButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func callButtonAction(_ sender: Any) {
        guard let number = URL(string: "tel://" + phoneNumber) else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction private func sendMessageButtonAction(_ sender: Any) {
        let urlWhats = "https://api.whatsapp.com/send?phone=\(phoneNumber)&text=Tengo%20una%20duda"
        if let url = URL(string: urlWhats), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            throwError(str: "El dispositivo no soporta el envío de mensajes, favor de intentar otra opción.")
        }
    }
}

// MARK: - Configure view

private extension HelpViewController {
    func configureView() {
        backView.roundCorners(16)
        callButton.roundCorners(callButton.frame.height/2)
        sendMessageButton.roundCorners(sendMessageButton.frame.height/2)
    }
}
