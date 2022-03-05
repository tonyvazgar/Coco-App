//
//  ShoppingCartV2ViewController.swift
//  Coco
//
//  Created by Erick Monfil on 28/02/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class ShoppingCartV2ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vistaNegocio: UIView!
    @IBOutlet weak var imgNegocio: UIImageView!
    @IBOutlet weak var btnPagar: UIButton!
    
    @IBOutlet weak var lblNombreLocation: UILabel!
    @IBOutlet weak var lblHorarioLocation: UILabel!
    @IBOutlet weak var lblDireccionLocation: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblPrecioCocoPoints: UILabel!
    
    
    var categoryId: String?
    var location: LocationsDataModel?
    
    var arrCanasta : [pedidoObject] = [pedidoObject]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imgNegocio.layer.cornerRadius = 94/2
        vistaNegocio.layer.cornerRadius = 94/2
        btnPagar.layer.cornerRadius = 20
        
        vistaNegocio.layer.shadowColor = UIColor.gray.cgColor
        vistaNegocio.layer.shadowOffset = CGSize(width: 3, height: 3)
        vistaNegocio.layer.shadowOpacity = 0.5
        vistaNegocio.layer.shadowRadius = 3
        
        tableView.register(UINib(nibName: "ProductCartV2TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        
        lblNombreLocation.text = location?.name ?? ""
        lblHorarioLocation.text = location?.schedule ?? ""
        lblDireccionLocation.text = location?.address ?? ""
        
        if let image = location?.imgURL {
            imgNegocio.kf.setImage(with: URL(string: image),
                                      placeholder: nil,
                                      options: [.transition(.fade(0.4))],
                                      progressBlock: nil,
                                      completionHandler: nil)
        }
        
        var data = Constatns.LocalData.canasta
        if data != nil {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                var canasta = try decoder.decode([pedidoObject].self, from: data!)
                
                var idcategoriaInt = Int(self.categoryId!)!
                for item in canasta {
                    if item.negocioId == idcategoriaInt {
                        self.arrCanasta.append(item)
                    }
                }
                print("numero de productos: \(arrCanasta.count)")
                let subT : Double = calcularSubtotal()
                lblSubTotal.text = "$\(subT)"
                let points = subT * 1000
                lblPrecioCocoPoints.text = "\(points)"
                tableView.reloadData()

            } catch {
                print("Unable to Decode pedido (\(error))")
            }
        }
        else {
            print("no hay produictos en la canasta")
        }
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pagarAction(_ sender: UIButton) {
        let viewController = UIStoryboard.shoppingCart.instantiate(DetallePedidoViewController.self)
        viewController.location = self.location
        viewController.categoryId = categoryId
        viewController.arrCanasta = arrCanasta
        viewController.subTotal = calcularSubtotal()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ShoppingCartV2ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCanasta.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.arrCanasta[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductCartV2TableViewCell
        cell.lblNombre.text = item.producto.name ?? ""
        cell.lblDescripcion.text = item.producto.description ?? ""
        cell.btnRestar.tag = indexPath.row
        cell.btnAumentar.tag = indexPath.row
        cell.lblCantidad.text = "\(item.cantidad)"
        cell.lblTotal.text = "$\(calcularTotalPedido(pedido: item))"
        cell.delegate = self
        return cell
    }
    
    
}

extension ShoppingCartV2ViewController : ProductoCanastaDelegate {
    func aumentarCantidad(index: Int) {
        
        self.arrCanasta[index].cantidad = self.arrCanasta[index].cantidad + 1
        tableView.reloadData()
        let subT : Double = calcularSubtotal()
        lblSubTotal.text = "$\(subT)"
        let points = subT * 1000
        lblPrecioCocoPoints.text = "\(points)"
    }
    
    func restarCantidad(index: Int) {
        let cantidad = self.arrCanasta[index].cantidad
        if cantidad > 1 {
            self.arrCanasta[index].cantidad = self.arrCanasta[index].cantidad - 1
        }
        tableView.reloadData()
        let subT : Double = calcularSubtotal()
        lblSubTotal.text = "$\(subT)"
        let points = subT * 1000
        lblPrecioCocoPoints.text = "\(points)"
    }
    
    func calcularTotalPedido(pedido : pedidoObject) -> Double{
        var tS = pedido.producto.price ?? "0"
        var total : Double = Double(tS)!
        
        for item in pedido.Configuracion {
            for producto in item.valores {
                if producto.tipo == "extras" {
                    total = total + (Double(producto.cantidad) * (Double(producto.precio) ?? 0))
                }
                else {
                    if producto.seleccionado == true {
                        total = total + Double(producto.precio)!
                    }
                }
            }
        }
        total = total * Double(pedido.cantidad)
        return total
    }
    
    func calcularSubtotal() -> Double {
        var total : Double = 0
        for item in self.arrCanasta {
           total = total + calcularTotalPedido(pedido: item)
        }
        return total
    }
    
}
