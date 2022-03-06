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
    
    @IBOutlet weak var lblSubTotal: UILabel!
    
    @IBOutlet weak var lblNumeroProductos: UILabel!
    @IBOutlet weak var txtComentarios: UITextView!
    
    @IBOutlet weak var btnVerCanasta: UIButton!
    
    
    
    
    private var loader: LoaderVC!
    var productId: String?
    var location: LocationsDataModel?
    private var product: ProducItem?
    var categoryId: String?
    var arrDetalle : [detalleItem] = [detalleItem]()
    var seccionSeleccionada : Int = 0
    var numeroProductos : Int = 1
    
    
    
    
    
    enum tipoSeccion : String {
        case extras = "extras"
        case ingrediente = "ingrediente"
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
        lblNumeroProductos.text = "\(self.numeroProductos)"
        vistaComentario.layer.cornerRadius = 30
        vistaComentario.layer.shadowColor = UIColor.black.cgColor
        vistaComentario.layer.shadowOffset = CGSize(width: 0, height: 30)
        vistaComentario.layer.shadowOpacity = 0.8
        vistaComentario.layer.shadowRadius = 30
            
        vistaStepper.layer.cornerRadius = 10
        btnAgregar.layer.cornerRadius = 20
        btnVerCanasta.layer.cornerRadius = 20
        btnVerCanasta.clipsToBounds = true
        
        tableView.register(UINib(nibName: "ProductCheckBoxTableViewCell", bundle: nil), forCellReuseIdentifier: "CellCheckBox")
        tableView.register(UINib(nibName: "ProductStepperTableViewCell", bundle: nil), forCellReuseIdentifier: "CellStepper")
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        btnVerCanasta.visibility = .gone
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
    
    
    @IBAction func sumaProductosAction(_ sender: UIButton) {
        self.numeroProductos = self.numeroProductos + 1
        self.lblNumeroProductos.text = "\(self.numeroProductos)"
        calcularTotal()
    }
    
    @IBAction func restaNumeroProductos(_ sender: UIButton) {
        if self.numeroProductos > 1 {
            self.numeroProductos = self.numeroProductos - 1
            self.lblNumeroProductos.text = "\(self.numeroProductos)"
        }
        calcularTotal()
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
                        let row = rowItem(nombre: i.name!, id: i.id_ingredient!, seleccionado: false, tipo: "ingrediente", precio: "0", cantidad: 0)
                        arrRows.append(row)
                    }
                    
                    let item = detalleItem(titulo: "Especifica tu producto", valores: arrRows, totalSeleccionar: 100, tituloTotal: "", tipo: "ingrediente")
                    
                    self?.arrDetalle.append(item)
                }
                
                //agregamos los opcion1
                let opciones1 = product.data!.options_1!
                if opciones1.count > 0 {
                    var arrRows : [rowItem] = [rowItem]()
                    for i in opciones1 {
                        let row = rowItem(nombre: i.name!, id: i.id_options!, seleccionado: false, tipo: "opcion1", precio: i.price!, cantidad: 0)
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
                        let row = rowItem(nombre: i.name!, id: i.id_options!, seleccionado: false, tipo: "opcion2", precio: i.price!, cantidad: 0)
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
                        let row = rowItem(nombre: "\(i.name!) ($\(i.price!) extra)", id: i.id_extra!, seleccionado: false, tipo: "extras", precio: i.price ?? "0", cantidad: 0)
                        arrRows.append(row)
                    }
                    
                    let item = detalleItem(titulo: "Agrega a tu Orden", valores: arrRows, totalSeleccionar: 100, tituloTotal: "selecciona varios ingrediente", tipo: "extras")
                    
                    self?.arrDetalle.append(item)
                }
                self?.calcularTotal()
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
    
    @IBAction func verCanastaAction(_ sender: UIButton) {
        let viewController = UIStoryboard.shoppingCart.instantiate(ShoppingCartV2ViewController.self)
        viewController.categoryId = self.categoryId
        viewController.location = self.location
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func irAcanastaAction(_ sender: UIButton) {
        let viewController = UIStoryboard.shoppingCart.instantiate(ShoppingCartV2ViewController.self)
        viewController.categoryId = self.categoryId
        viewController.location = self.location
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnAgregarAction(_ sender: UIButton) {
        /*
        let vc = UIStoryboard.shoppingCart.instantiate(ShoppingCartV2ViewController.self)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        */
        
        let pedido : pedidoObject = pedidoObject(cantidad: self.numeroProductos, producto: self.product!, Configuracion: self.arrDetalle, negocioId: Int(self.categoryId!)!, comentario: txtComentarios.text!)
        
        
        print("json de lo que se va agregar a la canasta")
        do {
        print("json de lo que se va agregar a la canasta")
        let dictionary: [String : Any] = try wrap(pedido)
        print(dictionary)
        } catch {
            print("Unable to Encode request (\(error))")
        }
        
        
        
        Constatns.LocalData.comentarios = txtComentarios.text!
        var data = Constatns.LocalData.canasta
        if data != nil {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                var canasta = try decoder.decode([pedidoObject].self, from: data!)
                
                canasta.append(pedido)
                
                
                //actualizamos el userdefault
                
                do {
                    // Create JSON Encoder
                    let encoder = JSONEncoder()

                    // Encode Note
                    let dataCanasta = try encoder.encode(canasta)

                    // Write/Set Data
                    Constatns.LocalData.canasta = dataCanasta
                    print("pedido agregado")
                    self.btnVerCanasta.visibility = .visible
                } catch {
                    print("Unable to Encode Array of canasta (\(error))")
                }

            } catch {
                print("Unable to Decode pedido (\(error))")
            }
        }
        else {
            var canasta : [pedidoObject] = [pedidoObject]()
            canasta.append(pedido)
            
            do {
                // Create JSON Encoder
                let encoder = JSONEncoder()

                // Encode Note
                let dataCanasta = try encoder.encode(canasta)

                // Write/Set Data
                Constatns.LocalData.canasta = dataCanasta
                self.btnVerCanasta.visibility = .visible
                print("producto agregado")

            } catch {
                print("Unable to Encode Array of canasta (\(error))")
            }
        }
            
        
        
        /*
        let viewController = UIStoryboard.shoppingCart.instantiate(ShoppingCartV2ViewController.self)
        
        navigationController?.pushViewController(viewController, animated: true)
         */
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
        case "ingrediente":
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellCheckBox", for: indexPath) as! ProductCheckBoxTableViewCell
            cell.checkBox.borderStyle = .square
            cell.checkBox.checkmarkColor = .orange
            cell.checkBox.checkmarkStyle = .tick
            cell.checkBox.checkmarkSize = 0.9
            cell.checkBox.borderLineWidth = 0
            
            cell.lblTitulo.text = sectionItem.valores[indexPath.row].nombre
            cell.checkBox.tag = indexPath.row
            cell.seccionSeleccionado = indexPath.section
            cell.delegate = self
            
            cell.checkBox.isChecked = sectionItem.valores[indexPath.row].seleccionado
            
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
            cell.checkBox.tag = indexPath.row
            cell.seccionSeleccionado = indexPath.section
            cell.checkBox.isChecked = sectionItem.valores[indexPath.row].seleccionado
            cell.delegate = self
            return cell
        
        case "opcion2":
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellCheckBox", for: indexPath) as! ProductCheckBoxTableViewCell
            cell.checkBox.borderStyle = .circle
            cell.checkBox.checkmarkColor = .orange
            cell.checkBox.checkmarkStyle = .circle
            cell.checkBox.isChecked = sectionItem.valores[indexPath.row].seleccionado
            cell.checkBox.borderLineWidth = 0
            cell.checkBox.checkmarkSize = 0.8
            cell.vistaCheck.layer.cornerRadius = 15
            cell.lblTitulo.text = sectionItem.valores[indexPath.row].nombre
            cell.checkBox.tag = indexPath.row
            cell.seccionSeleccionado = indexPath.section
            cell.delegate = self
            return cell
        
        case "extras":
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellStepper", for: indexPath) as! ProductStepperTableViewCell
            cell.lblTitulo.text = sectionItem.valores[indexPath.row].nombre
            cell.btnSuma.tag = indexPath.row
            cell.seccionSeleccionada = indexPath.section
            cell.btnPlus.tag = indexPath.row
            cell.btnResta.tag = indexPath.row
            cell.delegate = self
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
        let label2 = UILabel(frame: CGRect(x: 20, y: 22, width: self.view.frame.width - 40, height: 10))
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

extension ProducDetailV2ViewController : OpcionProductDelegate {
    func seleccionoOpcion(index: Int, status: Bool, seccion: Int) {
        print("Index: \(index) status: \(status) seccion: \(seccion)")
        
        var tipo = arrDetalle[seccion].tipo
        switch tipo {
        case "opcion1":
            print("opcion 1")
            
            if status == false {
                self.arrDetalle[seccion].valores[index].seleccionado = false
                tableView.reloadData()
            }
            else {
                let numeroMaximo = self.arrDetalle[seccion].totalSeleccionar
                var totalSeleccionados = 0
                for item in self.arrDetalle[seccion].valores {
                    if item.seleccionado == true {
                        totalSeleccionados = totalSeleccionados + 1
                    }
                }
                if totalSeleccionados >= numeroMaximo {
                    tableView.reloadData()
                }
                else {
                    self.arrDetalle[seccion].valores[index].seleccionado = true
                    tableView.reloadData()
                }
            }
            calcularTotal()
            break
        case "opcion2":
            print("opcion 2")
            if status == false {
                self.arrDetalle[seccion].valores[index].seleccionado = false
                tableView.reloadData()
            }
            else {
                let numeroMaximo = self.arrDetalle[seccion].totalSeleccionar
                var totalSeleccionados = 0
                for item in self.arrDetalle[seccion].valores {
                    if item.seleccionado == true {
                        totalSeleccionados = totalSeleccionados + 1
                    }
                }
                if totalSeleccionados >= numeroMaximo {
                    tableView.reloadData()
                }
                else {
                    self.arrDetalle[seccion].valores[index].seleccionado = true
                    tableView.reloadData()
                }
            }
            calcularTotal()
            break
        case "ingrediente":
            self.arrDetalle[seccion].valores[index].seleccionado = status
            tableView.reloadData()
            print("ingrediente")
            break
        default:
            break
        }
    }
    
    
    func calcularTotal(){
        var tS = self.product!.price ?? "0"
        var total : Double = Double(tS)!
        
        for item in self.arrDetalle {
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
        total = total * Double(numeroProductos)
        lblSubTotal.text = "$\(total)"
    }
}

extension ProducDetailV2ViewController : ExtrasDelegate {
    func seleccionoExtras(seccion: Int, index: Int, cantidad: Int) {
        print("Seccion:\(seccion) index :\(index) cantidad:\(cantidad)")
        self.arrDetalle[seccion].valores[index].cantidad = cantidad
        
        calcularTotal()
    }
}

struct rowItem : Codable {
    
    var nombre : String
    var id : String
    var seleccionado : Bool
    var tipo : String
    var precio : String
    var cantidad : Int
}

struct detalleItem : Codable {
    var titulo : String
    var valores : [rowItem]
    var totalSeleccionar : Int
    var tituloTotal : String
    var tipo : String
}



struct pedidoObject : Codable {
    var cantidad : Int
    var producto : ProducItem
    var Configuracion : [detalleItem]
    var negocioId : Int
    var comentario : String
}

struct canasta : Codable {
    var pedidos : [pedidoObject]
}
