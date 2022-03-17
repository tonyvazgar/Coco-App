//
//  LocationsListViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/8/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class LocationsListViewController: UITableViewController, SearchBarDelegate {
    func textDidChange(_ text: String) {
//        text.isEmpty ? clearResults() : filterResults(with: text)
        if(text.isEmpty) {
            clearResults()
        }else{
            filterResults(with: text)
        }
    }
    
    func textFieldShouldClear() {
        clearResults()
    }
    
    private(set) var locations: [LocationsDataModel] = []
    private(set) var locations_copia: [LocationsDataModel] = []
    private var loader = LoaderVC()
    var businessId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        configureTableView()
        configureTableHeaderView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let headerView = tableView.tableHeaderView else { return }
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationsTableViewCell.cellIdentifier, for: indexPath) as? LocationsTableViewCell else {
            return UITableViewCell()
        }
        
        let location = locations[indexPath.row]
        cell.locationName.text = location.name
        //cell.locationAddress.text = location.address
        cell.locationDistanceLabel.text = location.distance
        let estaAbierto = self.estaAbierto(horaInicio: location.horario_apertura ?? "", horaFin: location.horario_cierre ?? "")
        cell.locationScheduleLabel.text = estaAbierto == true ? "Abierto" : "Cerrado"
        if estaAbierto == true {
            cell.locationScheduleLabel.textColor = .black
        }
        else {
            cell.locationScheduleLabel.textColor = .red
        }
        cell.locationRatingLabel.text = location.rating
        
        if let image = location.imgURL {
            cell.locationImage.kf.setImage(with: URL(string: image),
                                           placeholder: nil,
                                           options: [.transition(.fade(0.4))],
                                           progressBlock: nil,
                                           completionHandler: nil)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        
        /*
        let viewController = UIStoryboard.home.instantiate(CategoriesContainerViewController.self)
        viewController.businessId = businessId
        viewController.locationId = location.id
        viewController.location = location
        navigationController?.pushViewController(viewController, animated: true)
        */
        let estaAbierto = self.estaAbierto(horaInicio: location.horario_apertura ?? "", horaFin: location.horario_cierre ?? "")
        
        if estaAbierto == true {
            Constatns.LocalData.aceptaPropina = location.propina ?? "true"
            Constatns.LocalData.tipoPickUpAceptados = location.pickups ?? ""
            let viewController = UIStoryboard.home.instantiate(CategoriesV2ViewController.self)
            viewController.businessId = businessId
            viewController.locationId = location.id
            viewController.location = location
            navigationController?.pushViewController(viewController, animated: true)
        }
        else {
            muestraMensajeAlert(mensaje: "Fuera de horario de servicio")
        }
        
        
        
         
    }
    
    
    func estaAbierto(horaInicio : String , horaFin : String) -> Bool{
        
        if horaInicio == ""{
            return false
        }
        if horaFin == "" {
            return false
        }
        
        let arrInicio = horaInicio.split(separator: ":")
        let arrFin = horaFin.split(separator: ":")
        var horaI : Int = 0
        var minutoI : Int = 0
        var horaF : Int = 0
        var minutoF : Int = 0
        
        if arrInicio.count == 2 {
            horaI = Int(arrInicio[0])!
            minutoI = Int(arrInicio[1])!
        }
        if arrFin.count == 2 {
            horaF = Int(arrFin[0])!
            minutoF = Int(arrFin[1])!
        }
        
        
        var timeExist:Bool
        let calendar = Calendar.current
        let startTimeComponent = DateComponents(calendar: calendar, hour:horaI, minute: minutoI)
        let endTimeComponent   = DateComponents(calendar: calendar, hour: horaF, minute: minutoF)

        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startTime    = calendar.date(byAdding: startTimeComponent, to:
        startOfToday)!
        let endTime      = calendar.date(byAdding: endTimeComponent, to:
        startOfToday)!

         if startTime <= now && now <= endTime {
            print("between 10 AM and 6:00 PM")
            timeExist = true
         } else {
            print("not between 10 AM and 6:00 PM")
            timeExist = false
         }
        
        return timeExist
    }
}

// MARK: - Configure Table

private extension LocationsListViewController {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: LocationsTableViewCell.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: LocationsTableViewCell.cellIdentifier)
    }
    func configureTableHeaderView() {
        let searchBar = SearchBarTableHeaderView.instantiate()
        searchBar.delegate = self
        tableView.tableHeaderView = searchBar
    }
}

// MARK: - Fetch Businesses

private extension LocationsListViewController {
    func requestData() {
        guard let businessId = businessId else { return }
        loader.showInView(aView: view, animated: true)
        LocationsFetcher.fetchLocations(businessId: businessId) { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error):
                print(error)
            case .success(let locations):
                self?.locations = locations
                self?.locations_copia = locations
                self?.tableView.reloadData()
            }
        }
    }
    func clearResults() {
        locations = locations_copia
        tableView.reloadData()
    }
    
    func filterResults(with text: String){
        locations = locations_copia.filter({
            $0.name?.lowercased().contains(text.lowercased()) ?? false
        })
        tableView.reloadData()
    }
}
