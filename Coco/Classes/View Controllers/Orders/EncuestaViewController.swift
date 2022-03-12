//
//  EncuestaViewController.swift
//  Coco
//
//  Created by Erick Monfil on 09/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class EncuestaViewController: UIViewController {

    @IBOutlet weak var vista1: UIView!
    @IBOutlet weak var vista2: UIView!
    @IBOutlet weak var vista3: UIView!
    @IBOutlet weak var vista4: UIView!
    @IBOutlet weak var btnFinalizar: UIButton!
    
    @IBOutlet weak var btn1Mal: UIButton!
    @IBOutlet weak var btn1Regular: UIButton!
    @IBOutlet weak var btn1Bien: UIButton!
    
    @IBOutlet weak var btn2Mal: UIButton!
    @IBOutlet weak var btn2Regular: UIButton!
    @IBOutlet weak var btn2Bien: UIButton!
    
    @IBOutlet weak var btn3Mal: UIButton!
    @IBOutlet weak var btn3Regular: UIButton!
    @IBOutlet weak var btn3Bien: UIButton!
    
    @IBOutlet weak var btn4Mal: UIButton!
    @IBOutlet weak var btn4Regular: UIButton!
    @IBOutlet weak var btn4Bien: UIButton!
    private var loader = LoaderVC()
    
    
    var opcion1 : Int = 0
    var opcion2 : Int = 0
    var opcion3 : Int = 0
    var opcion4 : Int = 0
    
    var idOrden : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gris = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 0.1)
        
        vista1.layer.cornerRadius = 30
        vista1.backgroundColor = .white
        vista1.layer.shadowColor = gris.cgColor
        vista1.layer.shadowOffset = CGSize(width: 0, height: 15)
        vista1.layer.shadowOpacity = 0.7
        vista1.layer.shadowRadius = 15
        
        vista2.layer.cornerRadius = 30
        vista2.backgroundColor = .white
        vista2.layer.shadowColor = gris.cgColor
        vista2.layer.shadowOffset = CGSize(width: 0, height: 15)
        vista2.layer.shadowOpacity = 0.7
        vista2.layer.shadowRadius = 15
        
        vista3.layer.cornerRadius = 30
        vista3.backgroundColor = .white
        vista3.layer.shadowColor = gris.cgColor
        vista3.layer.shadowOffset = CGSize(width: 0, height: 15)
        vista3.layer.shadowOpacity = 0.7
        vista3.layer.shadowRadius = 15
        
        vista4.layer.cornerRadius = 30
        vista4.backgroundColor = .white
        vista4.layer.shadowColor = gris.cgColor
        vista4.layer.shadowOffset = CGSize(width: 0, height: 15)
        vista4.layer.shadowOpacity = 0.7
        vista4.layer.shadowRadius = 15
        
        btnFinalizar.layer.cornerRadius = 20
        
        
        btn1Mal.tag = 1
        btn1Regular.tag = 2
        btn1Bien.tag = 3
        
        btn2Mal.tag = 1
        btn2Regular.tag = 2
        btn2Bien.tag = 3
        
        btn3Mal.tag = 1
        btn3Regular.tag = 2
        btn3Bien.tag = 3
        
        btn4Mal.tag = 1
        btn4Regular.tag = 2
        btn4Bien.tag = 3
        
        
        btn1Mal.layer.cornerRadius = 20
        btn1Regular.layer.cornerRadius = 20
        btn1Bien.layer.cornerRadius = 20
        
        btn2Mal.layer.cornerRadius = 20
        btn2Regular.layer.cornerRadius = 20
        btn2Bien.layer.cornerRadius = 20
        
        btn3Mal.layer.cornerRadius = 20
        btn3Regular.layer.cornerRadius = 20
        btn3Bien.layer.cornerRadius = 20
        
        btn4Mal.layer.cornerRadius = 20
        btn4Regular.layer.cornerRadius = 20
        btn4Bien.layer.cornerRadius = 20
        
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func calificaOPcion1(_ sender: UIButton) {
        print("opcion 1: \(sender.tag)")
        self.opcion1 = sender.tag
        switch sender.tag {
        case 1:
            blancoOpcion1()
            btn1Mal.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.1215686275, alpha: 1)
            break
        case 2:
            blancoOpcion1()
            btn1Regular.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.1215686275, alpha: 1)
            break
        case 3:
            blancoOpcion1()
            btn1Bien.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.1215686275, alpha: 1)
            break
        default:
            break
        }
    }
    
    
    @IBAction func calificaOpcion2(_ sender: UIButton) {
        self.opcion2 = sender.tag
        switch sender.tag {
        case 1:
            blancoOpcion2()
            btn2Mal.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.1215686275, alpha: 1)
            break
        case 2:
            blancoOpcion2()
            btn2Regular.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.1215686275, alpha: 1)
            break
        case 3:
            blancoOpcion2()
            btn2Bien.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.1215686275, alpha: 1)
            break
        default:
            break
        }
    }
    
    
    @IBAction func calificaOpcion3(_ sender: UIButton) {
        self.opcion3 = sender.tag
        switch sender.tag {
        case 1:
            blancoOpcion3()
            btn3Mal.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.1215686275, alpha: 1)
            break
        case 2:
            blancoOpcion3()
            btn3Regular.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.1215686275, alpha: 1)
            break
        case 3:
            blancoOpcion3()
            btn3Bien.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.1215686275, alpha: 1)
            break
        default:
            break
        }
    }
    
    
    @IBAction func calificaOpcion4(_ sender: UIButton) {
        self.opcion4 = sender.tag
        switch sender.tag {
        case 1:
            blancoOpcion4()
            btn4Mal.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.1215686275, alpha: 1)
            break
        case 2:
            blancoOpcion4()
            btn4Regular.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.1215686275, alpha: 1)
            break
        case 3:
            blancoOpcion4()
            btn4Bien.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.1215686275, alpha: 1)
            break
        default:
            break
        }
    }
    
    
    func blancoOpcion1(){
        btn1Mal.backgroundColor = .white
        btn1Regular.backgroundColor = .white
        btn1Bien.backgroundColor = .white
    }
    func blancoOpcion2(){
        btn2Mal.backgroundColor = .white
        btn2Regular.backgroundColor = .white
        btn2Bien.backgroundColor = .white
    }
    func blancoOpcion3(){
        btn3Mal.backgroundColor = .white
        btn3Regular.backgroundColor = .white
        btn3Bien.backgroundColor = .white
    }
    
    func blancoOpcion4(){
        btn4Mal.backgroundColor = .white
        btn4Regular.backgroundColor = .white
        btn4Bien.backgroundColor = .white
    }
    
    
    @IBAction func fionalizarEncuestaAction(_ sender: UIButton) {
        realizarEncuesta(id_order: self.idOrden)
    }
    
    func realizarEncuesta(id_order : String){
        if opcion1 == 0 || opcion2 == 0 || opcion3 == 0 || opcion4 == 0 {
            self.throwError(str: "Contesta todas la preguntas")
            return
        }
        loader.showInView(aView: view, animated: true)
        OrdersFetcher.realizarencuesta(id_pedido: id_order, opcion_1: "\(opcion1)", opcion_2: "\(opcion2)", opcion_3: "\(opcion3)", opcion_4: "\(opcion4)"){ [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error as FetcherErrors):
                self?.throwError(str: error.localizedDescription)
            case .failure:
                self?.throwError(str: "Ocurrió un error al avisar que ya llegue")
            case .success:
                //lanzamos el modal de que ya llego
                //mandarlo a ala pantalla de exito
                print("exito al realizar la encuesta")
                let nextViewController = UIStoryboard.orders.instantiate(EncuestaSuccessViewController.self)
                nextViewController.modalPresentationStyle = .fullScreen
                self!.present(nextViewController, animated:true, completion:nil)
                break
            }
        }
    }
    
}
