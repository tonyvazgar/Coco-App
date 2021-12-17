//
//  popover1ViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 01/06/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class popover1ViewController: UIViewController {
    
    var cantidad = UserDefaults.standard.value(forKey: "cocosOtorgados")
    
    @IBOutlet weak var cantidadDeCOcos: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if cantidad == nil {
            cantidad = 0
        }
        cantidadDeCOcos.text = "+ \(cantidad ?? 0)"
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.removeObject(forKey: "cocosOtorgados")
        UserDefaults.standard.set(false, forKey: "gotCocos")
    }
}
