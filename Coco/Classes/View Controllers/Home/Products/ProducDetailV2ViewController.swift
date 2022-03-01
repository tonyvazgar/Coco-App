//
//  ProducDetailV2ViewController.swift
//  Coco
//
//  Created by Erick Monfil on 24/02/22.
//  Copyright © 2022 Easycode. All rights reserved.
//

import UIKit

class ProducDetailV2ViewController: UIViewController {

    @IBOutlet weak var viewProduct: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vistaStepper: UIView!
    @IBOutlet weak var vistaComentario: UIView!
    @IBOutlet weak var altoTableView: NSLayoutConstraint!
    @IBOutlet weak var btnAgregar: UIButton!
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    
    
    
    private var loader: LoaderVC!
    var productId: String?
    var location: LocationsDataModel?
    private var product: ProducItem?
    
    var arrDetalle : [detalleItem] = [detalleItem]()
    
    enum tipoSeccion : String {
        case extras = "extras"
        case igrediente = "igrediente"
        case opcion1 = "opcion1"
        case opcion2 = "opcion2"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewProduct.layer.cornerRadius = 100
        imgProduct.layer.cornerRadius = 100
        viewProduct.layer.shadowColor = UIColor.gray.cgColor
        viewProduct.layer.shadowOffset = CGSize(width: 0, height: 4)
        viewProduct.layer.shadowOpacity = 0.4
        viewProduct.layer.shadowRadius = 2
        
        vistaComentario.layer.cornerRadius = 30
        vistaComentario.layer.shadowColor = UIColor.black.cgColor
        vistaComentario.layer.shadowOffset = CGSize(width: 0, height: 30)
        vistaComentario.layer.shadowOpacity = 0.8
        vistaComentario.layer.shadowRadius = 30
            
        vistaStepper.layer.cornerRadius = 10
        btnAgregar.layer.cornerRadius = 20
        
        tableView.register(UINib(nibName: "ProductCheckBoxTableViewCell", bundle: nil), forCellReuseIdentifier: "CellCheckBox")
        tableView.register(UINib(nibName: "ProductStepperTableViewCell", bundle: nil), forCellReuseIdentifier: "CellStepper")
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        requestData()
        
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if object is UITableView{
                if let newvalue = change?[.newKey]{
                    let newsize = newvalue as! CGSize
                    self.altoTableView.constant = newsize.height
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func requestData() {
        guard let productId = productId else { return }
        showLoader(&loader, view: view)
        ProductsFetcher.fetchProductDetailV2(productId: productId) { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error):
                self?.throwError(str: error.localizedDescription)
            case .success(let product):
                self?.product = product.data!.info!
                print("Numero de ingredientes: \(product.data!.ingredients!.count)")
                print("Numero de extras: \(product.data!.extras!.count)")
                print("Numero de opciones 1: \(product.data!.options_1!.count)")
                print("Numero de opciones 2: \(product.data!.options_2!.count)")
                let ingredientes = product.data!.ingredients!
                
                //agregamos los ingredientes
                if ingredientes.count > 0 {
                    var arrRows : [rowItem] = [rowItem]()
                    for i in ingredientes {
                        let row = rowItem(nombre: i.name!, id: i.id_ingredient!, seleccionado: false, tipo: "igrediente", precio: "0")
                        arrRows.append(row)
                    }
                    
                    let item = detalleItem(titulo: "Especifica tu producto", valores: arrRows, totalSeleccionar: 100, tituloTotal: "", tipo: "igrediente")
                    
                    self?.arrDetalle.append(item)
                }
                
                //agregamos los opcion1
                let opciones1 = product.data!.options_1!
                if opciones1.count > 0 {
                    var arrRows : [rowItem] = [rowItem]()
                    for i in opciones1 {
                        let row = rowItem(nombre: i.name!, id: i.id_options!, seleccionado: false, tipo: "opcion1", precio: i.price!)
                        arrRows.append(row)
                    }
                    
                    let numbers = product.data!.number_options_1!
                    if numbers.count > 0 {
                        let number = numbers[0]
                        let item = detalleItem(titulo: number.etiqueta!, valores: arrRows, totalSeleccionar: Int(number.selectable_options_1 ?? "0")!, tituloTotal: "Selecciona máximo \(number.selectable_options_1!)", tipo: "opcion1")
                        
                        self?.arrDetalle.append(item)
                    }
                    
                }
                
                //agregamos los opcion2
                let opciones2 = product.data!.options_2!
                if opciones2.count > 0 {
                    var arrRows : [rowItem] = [rowItem]()
                    for i in opciones2 {
                        let row = rowItem(nombre: i.name!, id: i.id_options!, seleccionado: false, tipo: "opcion2", precio: i.price!)
                        arrRows.append(row)
                    }
                    
                    let numbers = product.data!.number_options_2!
                    if numbers.count > 0 {
                        let number = numbers[0]
                        let item = detalleItem(titulo: number.etiqueta!, valores: arrRows, totalSeleccionar: Int(number.selectable_options_2 ?? "0")!, tituloTotal: "Selecciona máximo \(number.selectable_options_2!)", tipo: "opcion2")
                        
                        self?.arrDetalle.append(item)
                    }
                    
                }
                
                //agregamos los extras
                let extras = product.data!.extras!
                if extras.count > 0 {
                    var arrRows : [rowItem] = [rowItem]()
                    for i in extras {
                        let row = rowItem(nombre: "\(i.name!) ($\(i.price!) extra)", id: i.id_extra!, seleccionado: false, tipo: "extras", precio: i.price ?? "0")
                        arrRows.append(row)
                    }
                    
                    let item = detalleItem(titulo: "Agrega a tu Orden", valores: arrRows, totalSeleccionar: 100, tituloTotal: "selecciona varios ingrediente", tipo: "extras")
                    
                    self?.arrDetalle.append(item)
                }
                
                self?.tableView.reloadData()
                self?.fillInfo()
            }
        }
    }
    func fillInfo() {
        if self.product != nil {
            print("Nombre producto")
            print(product!.name ?? "")
            
            guard let image = product?.imageURL else { return }
            imgProduct.setImageKf(str: image)
            
            lblNombre.text = self.product!.name ?? ""
            lblPrecio.text = "$\(self.product!.price ?? "")"
            lblPoints.text = "\(self.product!.cocopoints ?? 0)"
            lblDescripcion.text = "\(self.product!.description ?? "")"
        }
    }
    
    @IBAction func btnAgregarAction(_ sender: UIButton) {
        /*
        let vc = UIStoryboard.shoppingCart.instantiate(ShoppingCartV2ViewController.self)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        */
        
        let viewController = UIStoryboard.shoppingCart.instantiate(ShoppingCartV2ViewController.self)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension ProducDetailV2ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrDetalle.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrDetalle[section].valores.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionItem = self.arrDetalle[indexPath.section]
        
        switch sectionItem.tipo {
        case "igrediente":
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellCheckBox", for: indexPath) as! ProductCheckBoxTableViewCell
            cell.checkBox.borderStyle = .square
            cell.checkBox.checkmarkColor = .orange
            cell.checkBox.checkmarkStyle = .tick
            cell.checkBox.checkmarkSize = 0.9
            cell.checkBox.borderLineWidth = 0
            
            cell.lblTitulo.text = sectionItem.valores[indexPath.row].nombre
            return cell
        case "opcion1":
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellCheckBox", for: indexPath) as! ProductCheckBoxTableViewCell
            cell.checkBox.borderStyle = .circle
            cell.checkBox.checkmarkColor = .orange
            cell.checkBox.checkmarkStyle = .circle
            cell.checkBox.borderLineWidth = 0
            cell.checkBox.checkmarkSize = 0.8
            cell.vistaCheck.layer.cornerRadius = 15
            cell.lblTitulo.text = sectionItem.valores[indexPath.row].nombre
            return cell
        
        case "opcion2":
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellCheckBox", for: indexPath) as! ProductCheckBoxTableViewCell
            cell.checkBox.borderStyle = .circle
            cell.checkBox.checkmarkColor = .orange
            cell.checkBox.checkmarkStyle = .circle
            cell.checkBox.borderLineWidth = 0
            cell.checkBox.checkmarkSize = 0.8
            cell.vistaCheck.layer.cornerRadius = 15
            cell.lblTitulo.text = sectionItem.valores[indexPath.row].nombre
            return cell
        
        case "extras":
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellStepper", for: indexPath) as! ProductStepperTableViewCell
            cell.lblTitulo.text = sectionItem.valores[indexPath.row].nombre
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellCheckBox", for: indexPath) as! ProductCheckBoxTableViewCell
            cell.checkBox.borderStyle = .square
            cell.checkBox.checkmarkColor = .orange
            cell.checkBox.checkmarkStyle = .tick
            cell.checkBox.checkmarkSize = 0.9
            cell.checkBox.borderLineWidth = 0
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: self.view.frame.width - 40, height: 21))
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = self.arrDetalle[section].titulo
        view.addSubview(label)
        let label2 = UILabel(frame: CGRect(x: 20, y: 25, width: self.view.frame.width - 40, height: 10))
        label2.font = UIFont.systemFont(ofSize: 12)
        label2.textColor = UIColor(red: 123/255, green: 123/255, blue: 123/255, alpha: 1)
        label2.text = self.arrDetalle[section].tituloTotal
        
        view.addSubview(label2)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 3))
        view.backgroundColor = .white
        
        
        //view.frame = CGRect(x: 20, y: 0, width: self.view.frame.width - 40, height: 3)
        let view2 = UIView(frame: CGRect(x: 20, y: 0, width: self.view.frame.width - 40, height: 3))
        view2.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1)
        view.addSubview(view2)
        return view
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
}


struct rowItem {
    
    var nombre : String
    var id : String
    var seleccionado : Bool
    var tipo : String
    var precio : String
}

struct detalleItem {
    var titulo : String
    var valores : [rowItem]
    var totalSeleccionar : Int
    var tituloTotal : String
    var tipo : String
}


