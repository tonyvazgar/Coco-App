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
    var saldo = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TarjetaNuevaTableViewCell", bundle: nil), forCellReuseIdentifier: "CellTarjeta")
        tableView.register(UINib(nibName: "TarjetaOxxoTableViewCell", bundle: nil), forCellReuseIdentifier: "CellOxxo")
        paymentForms = PaymentForms()
        requestData()
        
        
        guard let user = UserManagement.shared.user else { return }
        saldo = "\(user.current_balance ?? "--")"
        
    }
    
    @IBAction func agregarTarjetaAction(_ sender: UIButton) {
        let viewController = UIStoryboard.payments.instantiate(AgregarTarjetaViewController.self)
        
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
                
                
                let tar : PaymentForm = PaymentForm()
                tar.id = "0"
                tar.digits = "0"
                tar.type = "oxxo"
                tar.methodCustomer = ""
                tar.customer_id = ""
                tar.banco = "oxxo"
                tar.token_card = ""
                self?.arrTarjetas.append(tar)
                self?.tableView.reloadData()
                print("lista tarjetas")
                break
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
        case "visa":
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
            cell.vistaTarjeta.backgroundColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0, alpha: 1)
            cell.lblNumero.text = "\(item.digits ?? "")"
            break
        case "amex":
            cell.imgTarjeta.image = #imageLiteral(resourceName: "amex")
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
