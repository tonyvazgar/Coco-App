//
//  ListaTarjetasViewController.swift
//  Coco
//
//  Created by Erick Monfil on 02/03/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class ListaTarjetasViewController: UIViewController {
    private var loader = LoaderVC()
    var paymentForms: PaymentForms!
    var arrTarjetas : [PaymentForm] = [PaymentForm]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    var saldo = ""
    
    var isFromOrder : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TarjetaNuevaTableViewCell", bundle: nil), forCellReuseIdentifier: "CellTarjeta")
        tableView.register(UINib(nibName: "TarjetaOxxoTableViewCell", bundle: nil), forCellReuseIdentifier: "CellOxxo")
        paymentForms = PaymentForms()
        
        
        
        
        if isFromOrder == true {
            btnBack.visibility = .visible
        }
        else {
            btnBack.visibility = .gone
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let user = UserManagement.shared.user else { return }
        saldo = "\(user.current_balance ?? "0")"
        requestData()
    }
    
    @IBAction func agregarTarjetaAction(_ sender: UIButton) {
        let viewController = UIStoryboard.payments.instantiate(AgregarTarjetaViewController.self)
        viewController.isFromOrder = self.isFromOrder
        navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func requestData() {
        PaymentMethodsFetcher.fetchPaymentMethods { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error):
                print(error)
            case .success(let paymentMethods):
                //self?.paymentMethods = paymentMethods
                
                self?.arrTarjetas = paymentMethods
                
                /*
                let tar : PaymentForm = PaymentForm()
                tar.id = "0"
                tar.digits = "0"
                tar.type = "oxxo"
                tar.methodCustomer = ""
                tar.customer_id = ""
                tar.banco = "oxxo"
                tar.token_card = ""
                self?.arrTarjetas.append(tar)
 */
                self?.tableView.reloadData()
                print("lista tarjetas")
                break
            }
        }
    }
    
    func eliminaTarjeta(token_cliente : String, token_card : String){
        loader.showInView(aView: view, animated: true)
        PaymentMethodsFetcher.deleteCard(token_cliente: "\(token_cliente)", token_card: "\(token_card)") { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error as FetcherErrors):
                self?.throwError(str: error.localizedDescription)
            case .failure:
                self?.throwError(str: "Ocurrió un error al eliminar la tarjeta")
            case .success:
                self?.requestData()
            }
        }
    }
    
}

extension ListaTarjetasViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTarjetas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.arrTarjetas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTarjeta", for: indexPath) as! TarjetaNuevaTableViewCell
        
        switch  item.type{
        case "visa","Visa":
            cell.imgTarjeta.image = #imageLiteral(resourceName: "visa_sola")
            cell.imgTarjeta.layer.borderWidth = 1
            cell.imgTarjeta.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.imgTarjeta.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.imgTarjeta.layer.cornerRadius = 10
            cell.vistaTarjeta.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.1137254902, blue: 0.4509803922, alpha: 1)
            cell.lblNumero.text = "\(item.digits ?? "")"
            break
        case "mastercard":
            cell.imgTarjeta.image = #imageLiteral(resourceName: "mastercard")
            cell.imgTarjeta.layer.borderWidth = 1
            cell.imgTarjeta.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.imgTarjeta.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.imgTarjeta.layer.cornerRadius = 10
            cell.vistaTarjeta.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            cell.lblNumero.text = "\(item.digits ?? "")"
            break
        case "american_express":
            cell.imgTarjeta.image = #imageLiteral(resourceName: "amex")
            cell.imgTarjeta.layer.borderWidth = 1
            cell.imgTarjeta.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.imgTarjeta.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.imgTarjeta.layer.cornerRadius = 10
            cell.vistaTarjeta.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.4156862745, blue: 0.8352941176, alpha: 1)
            cell.lblNumero.text = "\(item.digits ?? "")"
            break
        case "oxxo":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellOxxo", for: indexPath) as! TarjetaOxxoTableViewCell
            cell.lblSaldo.text = "$\(saldo)"
            return cell
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //validar si es tarjeta oxxo entonce el tipo es 3
        
        if isFromOrder == true {
            let item = self.arrTarjetas[indexPath.row]
            if item.type == "oxxo" {
                Constatns.LocalData.paymentCanasta.tipoTarjeta = item.type ?? ""
                //Nuevatarjeta
                Constatns.LocalData.paymentCanasta.forma_pago = 3
                Constatns.LocalData.paymentCanasta.token_id = ""
                Constatns.LocalData.paymentCanasta.token_cliente = ""
                Constatns.LocalData.paymentCanasta.token_card = ""
                Constatns.LocalData.paymentCanasta.numeroTarjeta = "\(saldo)"
            }
            else {
                Constatns.LocalData.paymentCanasta.tipoTarjeta = item.type ?? ""
                //Nuevatarjeta
                Constatns.LocalData.paymentCanasta.forma_pago = 1
                Constatns.LocalData.paymentCanasta.token_id = ""
                Constatns.LocalData.paymentCanasta.token_cliente = "\(item.customer_id ?? "")"
                Constatns.LocalData.paymentCanasta.token_card = "\(item.token_card ?? "")"
                Constatns.LocalData.paymentCanasta.numeroTarjeta = "\(item.digits ?? "")"
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.arrTarjetas[indexPath.row].type != "oxxo" {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                    // delete the item here
            self.eliminaTarjeta(token_cliente: self.arrTarjetas[indexPath.row].customer_id ?? "", token_card: self.arrTarjetas[indexPath.row].token_card ?? "")
                    completionHandler(true)
                }
                deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = .white
                let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
                return configuration
    }
    
}
