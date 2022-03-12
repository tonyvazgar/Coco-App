//
//  PedidoPreparacionTableViewCell.swift
//  Coco
//
//  Created by Erick Monfil on 07/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit
import  Kingfisher
import Lottie
protocol PedidoPreparacionDelegate {
    func comoLLegarPreparacion(index : Int)
}
class PedidoPreparacionTableViewCell: UITableViewCell {

    @IBOutlet weak var vistaTarjeta: UIView!
    @IBOutlet weak var vistaTop: UIView!
    @IBOutlet weak var vistaImagen: UIView!
    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var lblNombreStore: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblTiempo: UILabel!
    @IBOutlet weak var btnComoLLegar: UIButton!
    @IBOutlet weak var tituloTiempo: UILabel!
    @IBOutlet weak var lblTiempoCero: UILabel!
    
    var delegate : PedidoPreparacionDelegate?
    
    @IBOutlet weak var contenedorAnimacion: UIView!
    public var loaderAnimation: AnimationView!
    
    @IBOutlet weak var lblCodigo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gris = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.1)
        btnComoLLegar.layer.cornerRadius = 20
        vistaTarjeta.layer.cornerRadius = 30
        vistaTarjeta.backgroundColor = .white
        vistaTarjeta.layer.shadowColor = gris.cgColor
        vistaTarjeta.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaTarjeta.layer.shadowOpacity = 0.7
        vistaTarjeta.layer.shadowRadius = 15
        
        
        vistaTop.layer.cornerRadius = 30
        vistaTop.backgroundColor = .white
        vistaTop.layer.shadowColor = gris.cgColor
        vistaTop.layer.shadowOffset = CGSize(width: 0, height: 15)
        vistaTop.layer.shadowOpacity = 0.7
        vistaTop.layer.shadowRadius = 15
        
        
        vistaImagen.layer.cornerRadius = 94/2
        imgStore.layer.cornerRadius = 94/2
        vistaImagen.layer.shadowColor = UIColor.gray.cgColor
        vistaImagen.layer.shadowOffset = CGSize(width: 3, height: 3)
        vistaImagen.layer.shadowOpacity = 0.5
        vistaImagen.layer.shadowRadius = 3
        
     
        
        
        contenedorAnimacion.clipsToBounds = true
        
        loaderAnimation = AnimationView(name: "cooking")
        loaderAnimation.frame = CGRect(origin: .zero, size: contenedorAnimacion.frame.size)
        loaderAnimation.backgroundColor = .clear
        loaderAnimation.loopMode = .loop
        loaderAnimation.animationSpeed = 0.7
        contenedorAnimacion.addSubview(loaderAnimation)
        
        loaderAnimation.play()
        
    }
    
    func countDownTest(minutes: Int, seconds: Int) {
        var minutesRemaining = minutes
        var secondsRemaining = seconds
        Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { [weak self] timer in
            if secondsRemaining < 6 {
                secondsRemaining = (60 + secondsRemaining) - 6
                minutesRemaining -= 1
                if minutesRemaining <= 0 {
                    //self?.currentEstimatedTime.isHidden = true
                    timer.invalidate()
                } else {
                    //self?.estimatedTimeText.text = "\(minutesRemaining) Minutos"
                    self!.lblTiempo.text = "\(minutesRemaining) Minutos"
                }
            } else {
                secondsRemaining -= 6
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func comoLLegarAction(_ sender: UIButton) {
        delegate?.comoLLegarPreparacion(index: sender.tag)
    }
    
}
