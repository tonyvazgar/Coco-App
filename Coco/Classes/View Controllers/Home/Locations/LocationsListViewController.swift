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
        cell.locationScheduleLabel.text = location.schedule
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
        
        
        Constatns.LocalData.aceptaPropina = location.propina ?? "true"
        let viewController = UIStoryboard.home.instantiate(CategoriesV2ViewController.self)
        viewController.businessId = businessId
        viewController.locationId = location.id
        viewController.location = location
        navigationController?.pushViewController(viewController, animated: true)
         
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
