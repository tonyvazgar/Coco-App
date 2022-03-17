//
//  ListaPedidosViewController.swift
//  Coco
//
//  Created by Erick Monfil on 05/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit
import BottomPopup

class ListaPedidosViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var loader = LoaderVC()
    private(set) var orders: [Order] = []
    
    var gameTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "PedidoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CellOk")
        tableView.register(UINib(nibName: "PedidoPreparacionTableViewCell", bundle: nil), forCellReuseIdentifier: "CellPreparacion")
        tableView.register(UINib(nibName: "PedidoListoTableViewCell", bundle: nil), forCellReuseIdentifier: "CellListo")
        tableView.register(UINib(nibName: "PedidoEntregadoTableViewCell", bundle: nil), forCellReuseIdentifier: "CellEntregado")
        
        tableView.register(UINib(nibName: "PedidoCanceladoTableViewCell", bundle: nil), forCellReuseIdentifier: "CellCancelado")
        
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,selector: #selector(appMovedToForeground),name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter.addObserver(self,selector: #selector(appMovedToBackground),name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func callPullToRefresh(){
        requestData()
    }
    @objc func appMovedToBackground() {
        print("se fue a background")
        gameTimer?.invalidate()
    }
    
    @objc func appMovedToForeground() {
        print("App moved to ForeGround!")
        requestData()
    }
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let id = UserManagement.shared.id_user ?? ""
        if id == "" {
            self.sessionEnd()
        }
        else {
            requestData()
            
            if let tabItems = tabBarController?.tabBar.items {
                // In this case we want to modify the badge number of the third tab:
                let tabItem = tabItems[2]
                tabItem.badgeValue = nil
            }
        }
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameTimer?.invalidate()
    }
    @objc func runTimedCode(){
        print("refrescando informacion")
        tableView.reloadData()
    }
    
    func requestData() {
        OrdersFetcher.fetchOrders { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let orders):
                
                DispatchQueue.main.asyncAfter(deadline: .now()){
                   self?.tableView.refreshControl?.endRefreshing()
                    self?.orders = []
                    
                    
                    for item in orders {
                            self?.orders.append(item)
                    }
                    
                    
                    if (self?.orders.count)! > 5 {
                        self?.orders = Array((self?.orders[0...4])!)
                    }
                    
                    var arrOrdenesPendientes : [Order] = [Order]()
                    
                    for item in self?.orders ?? [] {
                       // if item.status == "1" || item.status == "2" || item.status == "3" || item.status == "4" {
                            arrOrdenesPendientes.append(item)
                        //}
                    }
                    
                    self?.orders = arrOrdenesPendientes
                    
                    self?.requestInitialData()
                    self?.tableView.reloadData()
                    
                    
                    
                    var numeroPendientes : Int = 0
                    for item in self?.orders ?? [] {
                        if item.status == "1" || item.status == "2" || item.status == "3" {
                            numeroPendientes = numeroPendientes + 1
                        }
                    }
                    if let tabItems = self?.tabBarController?.tabBar.items {
                        // In this case we want to modify the badge number of the third tab:
                        let tabItem = tabItems[2]
                        if numeroPendientes > 0 {
                            tabItem.badgeValue = "\((numeroPendientes))"
                        }
                        else {
                            tabItem.badgeValue = nil
                        }
                        
                    }
                    
                    if self?.gameTimer != nil {
                        self?.gameTimer?.invalidate()
                    }
                        self?.gameTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self?.runTimedCode), userInfo: nil, repeats: true)
                    
                    
               }
                
                
            }
        }
    }
    
    func requestInitialData() {
        HomeFetcher.fetchMain { [weak self] result in
            switch result {
            case .failure(let error):
                self?.throwError(str: error.localizedDescription)
            case .success(let data):
                DispatchQueue.main.async {
                    //self?.populateContent(with: data)
                    UserManagement.shared.user = data.info
                    
                    if Constatns.LocalData.paymentCanasta.forma_pago == 3{
                        Constatns.LocalData.paymentCanasta.numeroTarjeta = data.info?.current_balance ?? "0"
                    }
                }
            }
        }
    }
    
    func yaLlegueService(id_order : String){
        loader.showInView(aView: view, animated: true)
        OrdersFetcher.yaLlegue(id_order: id_order) { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error as FetcherErrors):
                self?.throwError(str: error.localizedDescription)
            case .failure:
                self?.throwError(str: "Ocurrió un error al avisar que ya llegue")
            case .success:
                //lanzamos el modal de que ya llego
                self?.presentarModal()
                break
            }
        }
    }
    
    func presentarModal(){
        guard let popupViewController = storyboard?.instantiateViewController(withIdentifier: "YaLLegueViewController") as? YaLLegueViewController else { return }
        popupViewController.height = 350
        popupViewController.topCornerRadius = 35
        popupViewController.presentDuration = 0.5
        popupViewController.dismissDuration = 0.5
        popupViewController.shouldDismissInteractivelty = true
        //popupViewController.popupDelegate = self
        present(popupViewController, animated: true, completion: nil)
    }
}

extension ListaPedidosViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.orders[indexPath.row]
        
        switch item.status {
        case "1":
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellOk", for: indexPath) as! PedidoItemTableViewCell
            cell.lblNombreStore.text = item.business ?? ""
            cell.btnOCmoLLegar.tag = indexPath.row
            cell.delegate = self
            cell.lblCodigo.text = "#\(item.codigo ?? "")"
            if let image = item.imageURL {
                cell.imgStore.kf.setImage(with: URL(string: image),
                                          placeholder: nil,
                                          options: [.transition(.fade(0.4))],
                                          progressBlock: nil,
                                          completionHandler: nil)
            }
            return cell
        case "2":
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellPreparacion", for: indexPath) as! PedidoPreparacionTableViewCell
            cell.lblNombreStore.text = item.business ?? ""
            if let image = item.imageURL {
                cell.imgStore.kf.setImage(with: URL(string: image),
                                          placeholder: nil,
                                          options: [.transition(.fade(0.4))],
                                          progressBlock: nil,
                                          completionHandler: nil)
            }
            cell.btnComoLLegar.tag = indexPath.row
            //cell.countDownTest(minutes: 5, seconds: 30)
            cell.loaderAnimation.play()
            cell.delegate = self
            cell.lblCodigo.text = "#\(item.codigo ?? "")"
            let tiempo = self.getHoursAndMinutes(minutosAsumar: Int(item.tiempoEstimado ?? "0")!, fechaAceptacion: "\(item.fecha_aceptado ?? "")")
            if tiempo == 0 {
                cell.lblTiempo.visibility = .gone
                cell.tituloTiempo.visibility = .gone
                cell.lblTiempoCero.visibility = .visible
            }
            else {
                cell.lblTiempo.visibility = .visible
                cell.tituloTiempo.visibility = .visible
                cell.lblTiempoCero.visibility = .gone
                cell.lblTiempo.text = "\(tiempo):00"
            }
            
            return cell
        case "3":
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellListo", for: indexPath) as! PedidoListoTableViewCell
            cell.lblNombreStore.text = item.business ?? ""
            if let image = item.imageURL {
                cell.imgStore.kf.setImage(with: URL(string: image),
                                          placeholder: nil,
                                          options: [.transition(.fade(0.4))],
                                          progressBlock: nil,
                                          completionHandler: nil)
            }
            cell.lblCodigo.text = "#\(item.codigo ?? "")"
            cell.btnYaLLegue.tag = indexPath.row
            cell.btnOCmoLLegar.tag = indexPath.row
            cell.btnComoLLegarGrande.tag = indexPath.row
            
            if item.pickup! == "2" {
                cell.btnComoLLegarGrande.visibility = .gone
                cell.btnYaLLegue.visibility = .visible
                cell.btnOCmoLLegar.visibility = .visible
            }
            else {
                cell.btnComoLLegarGrande.visibility = .visible
                cell.btnYaLLegue.visibility = .gone
                cell.btnOCmoLLegar.visibility = .gone
            }
            cell.delegate = self
            return cell
        case "4":
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellEntregado", for: indexPath) as! PedidoEntregadoTableViewCell
            cell.lblNombreStore.text = item.business ?? ""
            cell.lblCodigo.text = "#\(item.codigo ?? "")"
            if let image = item.imageURL {
                cell.imgStore.kf.setImage(with: URL(string: image),
                                          placeholder: nil,
                                          options: [.transition(.fade(0.4))],
                                          progressBlock: nil,
                                          completionHandler: nil)
            }
            cell.btnCalificar.tag = indexPath.row
            let valorado = item.valorado ?? "0"
            if valorado == "1" {
                cell.btnCalificar.setTitle("Pedido calificado", for: .normal)
            }
            else {
                cell.btnCalificar.setTitle("Califica tu experiencia", for: .normal)
            }
            cell.delegate = self
            return cell
        case "5":
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellCancelado", for: indexPath) as! PedidoCanceladoTableViewCell
            cell.lblNombreStore.text = item.business ?? ""
           
            cell.lblCodigo.text = "#\(item.codigo ?? "")"
            if let image = item.imageURL {
                cell.imgStore.kf.setImage(with: URL(string: image),
                                          placeholder: nil,
                                          options: [.transition(.fade(0.4))],
                                          progressBlock: nil,
                                          completionHandler: nil)
            }
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    
}

extension ListaPedidosViewController : PedidoPendienteDelegate, PedidoPreparacionDelegate, PedidoListoDelegate,PedidoEntregadoDelegate {
    func calificarPedido(index: Int) {
        
        let valorado = orders[index].valorado ?? "0"
        if valorado == "0" {
            let nextViewController = UIStoryboard.orders.instantiate(EncuestaViewController.self)
            nextViewController.modalPresentationStyle = .fullScreen
            nextViewController.idOrden = orders[index].id!
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    func comoLLegarListo(index: Int) {
        mostrarMenuComoLLegar(index: index)
    }
    
    func yaLLegueListo(index: Int) {
        print("id:\(self.orders[index].id!)")
        self.yaLlegueService(id_order: self.orders[index].id!)
    }
    
    func comoLLegarPreparacion(index: Int) {
        mostrarMenuComoLLegar(index: index)
    }
    
    func comoLLegarPendiente(index: Int) {
        mostrarMenuComoLLegar(index: index)
    }
    
    func mostrarMenuComoLLegar(index : Int){
        let alert = UIAlertController(title: "Como llegar", message: "", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Abrir Mapas", style: .default , handler:{ (UIAlertAction)in
                let url = URL(string: "maps://?saddr=&daddr=\(self.orders[index].latitud ?? "0"),\(self.orders[index].longitud ?? "0")")
                if UIApplication.shared.canOpenURL(url!) {
                      UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Abrir Google Maps", style: .default , handler:{ (UIAlertAction)in
                
                let latitude = self.orders[index].latitud ?? "0"
                let longitude = self.orders[index].longitud ?? "0"
                
                self.openGoogleMaps(lat: latitude, long: longitude)
                
            }))

            
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Dismiss button")
            }))

            
            //uncomment for iPad Support
            //alert.popoverPresentationController?.sourceView = self.view

            self.present(alert, animated: true, completion: {
                print("completion block")
            })
    }
    
    func openGoogleMaps(lat : String, long : String) {
           /*
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
          UIApplication.shared.openURL(URL(string:
            "comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic")!)
        } else {
          print("Can't use comgooglemaps://");
        }*/

            if let url = URL(string: "comgooglemaps://?q=\(lat),\(long)&center=\(lat),\(long)&zoom=15&views=transit") {
                UIApplication.shared.open(url, options: [:])
            }
            else {
                print("Can't use comgooglemaps://")
                UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(lat),\(long)&zoom=14&views=traffic")!, options: [:], completionHandler: nil)
            }
           
        }
}


extension ListaPedidosViewController {
    func getHoursAndMinutes(minutosAsumar: Int, fechaAceptacion:String) -> Int{
        if fechaAceptacion != "" {
            let isoDate = fechaAceptacion
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "es_MX")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: isoDate) {
              // do something with date...
                var calendar = Calendar.current
                let currentdate = Date()
                let currenthour = calendar.component(.hour, from: currentdate)
                let currentminute = calendar.component(.minute, from: currentdate)
                let currentsecond = calendar.component(.second, from: currentdate)
                let currentday = calendar.component(.day, from: currentdate)
                
                
                let addminutes = date.addingTimeInterval(TimeInterval(minutosAsumar) * 60)
                
                
                let hour = calendar.component(.hour, from: addminutes)
                let minute = calendar.component(.minute, from: addminutes)
                let second = calendar.component(.second, from: addminutes)
                let dia = calendar.component(.day, from: addminutes)
                
                print("dia entrega:\(dia)")
                print("dia actual:\(currentday)")
                if dia == currentday {
                    print("hora de entrega:\(hour)")
                    print("Hora actual:\(currenthour)")
                    let horasRestantes = hour - currenthour
                    var tiempoRestante = 0
                    if horasRestantes >= 0 {
                        if horasRestantes == 0 {
                            let minutosFaltantes = minute - currentminute
                            if minutosFaltantes <= 0 {
                                return 0
                            }
                            else {
                                return minutosFaltantes
                            }
                        }
                        else {
                            let horasMinutos = horasRestantes * 60
                            let minutosFaltantes = minute - currentminute
                            let suma = minutosFaltantes + horasMinutos
                            if suma <= 0 {
                                return 0
                            }
                            else {
                                return suma
                            }
                        }
                    }
                    else {
                        return 0
                    }
                }
                else {
                    return 0
                }
                
            }
            else {
                return 0
            }
        }
        else {
            return 0
        }
        
    }
}
