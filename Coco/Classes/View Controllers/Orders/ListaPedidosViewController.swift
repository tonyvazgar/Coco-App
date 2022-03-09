//
//  ListaPedidosViewController.swift
//  Coco
//
//  Created by Erick Monfil on 05/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class ListaPedidosViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var loader = LoaderVC()
    private(set) var orders: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "PedidoItemTableViewCell", bundle: nil), forCellReuseIdentifier: "CellOk")
        tableView.register(UINib(nibName: "PedidoPreparacionTableViewCell", bundle: nil), forCellReuseIdentifier: "CellPreparacion")
        tableView.register(UINib(nibName: "PedidoListoTableViewCell", bundle: nil), forCellReuseIdentifier: "CellListo")
        tableView.register(UINib(nibName: "PedidoEntregadoTableViewCell", bundle: nil), forCellReuseIdentifier: "CellEntregado")
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    @objc func callPullToRefresh(){
        requestData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestData()
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
                        if item.status == "1" || item.status == "2" || item.status == "3" || item.status == "4" {
                            self?.orders.append(item)
                        }
                    }
                    self?.orders = orders
                    self?.requestInitialData()
                    self?.tableView.reloadData()
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
                break
            }
        }
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
            cell.delegate = self
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
            cell.btnYaLLegue.tag = indexPath.row
            cell.btnOCmoLLegar.tag = indexPath.row
            cell.delegate = self
            return cell
        case "4":
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellEntregado", for: indexPath) as! PedidoEntregadoTableViewCell
            cell.lblNombreStore.text = item.business ?? ""
            
            if let image = item.imageURL {
                cell.imgStore.kf.setImage(with: URL(string: image),
                                          placeholder: nil,
                                          options: [.transition(.fade(0.4))],
                                          progressBlock: nil,
                                          completionHandler: nil)
            }
            cell.btnCalificar.tag = indexPath.row
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    
}

extension ListaPedidosViewController : PedidoPendienteDelegate, PedidoPreparacionDelegate, PedidoListoDelegate,PedidoEntregadoDelegate {
    func calificarPedido(index: Int) {
        
    }
    
    func comoLLegarListo(index: Int) {
        mostrarMenuComoLLegar(index: index)
    }
    
    func yaLLegueListo(index: Int) {
        
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
