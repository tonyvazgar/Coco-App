//
//  newCodeViewController.swift
//  Coco
//
//  Created by Brandon Gonzalez on 24/02/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import Hero

class newCodeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCodeButton: UIButton!
    @IBOutlet weak var tuCodigo: UILabel!
    @IBOutlet weak var referalCode: UITextField!
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var gradientBackground: GradientView!
    @IBOutlet weak var shareCoco: UIButton!
    
    let reuseDocument = "DocumentoCellCoupons"
    let reuseDocument2 = "DocumentoCUmpones"
    let userID = UserManagement.shared.id_user
    var codes : [Dictionary<String, Any>] = []
    private var mainData: Main!
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getThemCodes()
        mainData = Main()
        updateLabels()
        NotificationCenter.default.addObserver(self, selector: #selector(shareTheCode), name: Notification.Name(rawValue: "shareCoco"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addNewCode), name: Notification.Name(rawValue: "exchangeCode"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newCode), name: Notification.Name(rawValue: "newCodeReload"), object: nil)
        addCodeButton.isHidden = true
    }
    
    //MARK: Tableview
    
    func updateLabels() {
        print("Updating labels")
        mainData.requestUserMain { (result) in
            print("Labels data requested")
            switch result {
            case .failure(let errorMssg):
                self.throwError(str: errorMssg)
            case .success(_):
                print("Labels data was succesfully received, updating texts")
                DispatchQueue.main.async {
                    self.tuCodigo.text = "Tu código: \n \(self.mainData.info?.codigo_referido ?? "--")"
                    print("Text populated")
                }
            }
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let documentXib = UINib(nibName: "promoCodesTableViewCell", bundle: nil)
        tableView.register(documentXib, forCellReuseIdentifier: reuseDocument)
        let documentXib2 = UINib(nibName: "codeSharingTableViewCell", bundle: nil)
        tableView.register(documentXib2, forCellReuseIdentifier: reuseDocument2)
        tableView.allowsSelection = false
    }
    
    @IBAction func codeShareButton(_ sender: Any) {
        let text = "¡Descarga Cocoapp y usa mi código para obtener saldo gratis en tu primera recarga! CODIGO: \(mainData.info?.codigo_referido ?? "--") Descargala en: https://apps.apple.com/mx/app/coco-app/id1470991257?l=en"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func shareTheCode() {
        let text = "¡Descarga Cocoapp y usa mi código para obtener saldo gratis en tu primera recarga! CODIGO: \(mainData.info?.codigo_referido ?? "--") Descargala en: https://apps.apple.com/mx/app/coco-app/id1470991257?l=en"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + codes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 550
        }
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseDocument2, for: indexPath)
            return cell
        } else {
            let document = codes[indexPath.row - 1]
            let amount = document["monto"]
            let date = document["fecha"]
            let token = document["token"]
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseDocument, for: indexPath)
            if let cell = cell as? promoCodesTableViewCell {
                DispatchQueue.main.async {
                    cell.montoLabel.text = amount as! String
                    cell.fechaLabel.text = date as! String
                    cell.codigoLabel.text = token as! String
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    @IBAction func exchangeButton(_ sender: Any) {
        // No sé que hace este boton pero no lo voy a quitar porque todo se puede romper.
    }
    
    @IBAction func promoCodes(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCode(_ sender: Any) {
        let addCardVC = addNewPromoCodeViewController(nibName: "addNewPromoCodeViewController", bundle: nil)
        self.present(addCardVC, animated: true, completion: nil)
    }
    
    @objc func addNewCode() {
        let newCode = "\(UserDefaults.standard.value(forKey: "code") ?? "--")"
        if  newCode == "" {
            let alert = UIAlertController(title: "Falta un dato", message: "Debes escribir un codigo", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Reintentar", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if newCode == "--" {
            let alert = UIAlertController(title: "Falta un dato", message: "Debes escribir un codigo", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Reintentar", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let myOwnCode = "\(mainData.info?.codigo_referido ?? "No Code")"
        
        if newCode == myOwnCode {
            let alert = UIAlertController(title: "¿Usando tu propio codigo?", message: "No puedes usar tu propio codigo.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Usar otro", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let url = URL(string: General.endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=ChangeCodePromotional&id_user="+userID!+"&token="+"\(newCode)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            if let parseJSON = json {
                if let state = parseJSON["state"]{
                    let stateString = "\(state)"
                    if stateString == "600" {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error", message: "Ya usaste este codigo.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Intentar otro.", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                    
                    if stateString == "200" {
                        NotificationCenter.default.post(name: Notification.Name("reloadBalance"), object: nil)
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "¡Exito!", message: "Se ha canjeado el código exitosamente.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Genial", style: .cancel, handler: { action in
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "newCodeReload"), object: nil)
                            }))
                            self.present(alert, animated: true)
                        }
                        
                    } else if stateString == "101" {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error", message: "El codigo no existe.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Volver a intentar o corregir.", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error", message: "Hay un problema con el servidor, inténtalo de nuevo más tarde.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    @objc func newCode() {
        codes.removeAll()
        getThemCodes()
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    func getThemCodes() {
        let url = URL(string: General.endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=getCodePromotionals&id_user="+userID!
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, response != nil else {
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            if let dictionary = json as? Dictionary<String, AnyObject> {
                if let items = dictionary["data"] as? [Dictionary<String, Any>] {
                    for d in items {
                        self.codes.append(d)
                    }
                }
            }
            DispatchQueue.main.async {
                if self.codes.count > 0 {
                    self.tableView.reloadData()
                }
            }
        }.resume()
    }
}

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}
