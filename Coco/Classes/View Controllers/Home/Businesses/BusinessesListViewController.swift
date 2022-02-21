//
//  BusinessesListViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/8/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class BusinessesListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private(set) var staticBusinessList: [Business] = []
    private(set) var businesses: [Business] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        configureTableView()
        configureTableHeaderView()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        guard let headerView = tableView.tableHeaderView else { return }
//        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//
//        if headerView.frame.size.height != size.height {
//            headerView.frame.size.height = size.height
//            tableView.tableHeaderView = headerView
//            tableView.layoutIfNeeded()
//        }
//    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Compute the dimension of a cell for an NxN layout with space S between
        // cells.  Take the collection view's width, subtract (N-1)*S points for
        // the spaces between the cells, and then divide by N to find the final
        // dimension for the cell's width and height.

        let cellsAcross: CGFloat = 2.5
        let spaceBetweenCells: CGFloat = 5
        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        return CGSize(width: dim, height: dim*1.2)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BusinessesCollectionViewCell.cellIdentifier, for: indexPath) as? BusinessesCollectionViewCell else {
            return BusinessesCollectionViewCell()
        }
        
        let business = businesses[indexPath.row]
        cell.categoryLabel.text = business.name
//                cell.businessAddress.text = business.address
//                cell.businessDistanceLabel.text = business.distance
                
        if let image = business.imgURL {
            cell.categoryImage.kf.setImage(with: URL(string: image),
                                                   placeholder: nil,
                                                   options: [.transition(.fade(0.4))],
                                                   progressBlock: nil,
                                                   completionHandler: nil)
        }
        return cell
        
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UIScreen.main.bounds.width/2
//    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
        let business = businesses[indexPath.row]
        let viewController = UIStoryboard.home.instantiate(LocationsContainerViewController.self)
        viewController.businessId = business.id
        viewController.textoSeccion = business.name!
        navigationController?.pushViewController(viewController, animated: true)
        */
        
        /*
        let business = businesses[indexPath.row]
        let viewController = UIStoryboard.home.instantiate(CounterViewController.self)

        navigationController?.present(viewController, animated: true, completion: nil)
        */
        
        
        
        let business = businesses[indexPath.row]
                 let viewController = UIStoryboard.home.instantiate(CounterViewController.self)

                 navigationController?.present(viewController, animated: true, completion: nil)
         
    }
}

// MARK: - Configure Table

private extension BusinessesListViewController {
    func configureTableView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white     //Para solucionar el bug de que se ve en algunos dispositivos negro el fondo
        
//        tableView.separatorStyle = .none
//        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: BusinessesCollectionViewCell.cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: BusinessesCollectionViewCell.cellIdentifier)
    }
    
    func configureTableHeaderView() {
//        let searchBar = SearchBarTableHeaderView.instantiate()
//        searchBar.delegate = self
//        tableView.tableHeaderView = searchBar
    }
}

// MARK: - Search bar delegate

extension BusinessesListViewController: SearchBarDelegate {
    func textDidChange(_ text: String) {
        text.isEmpty ? clearResults() : filterResults(with: text)
    }
    
    func textFieldShouldClear() {
       clearResults()
    }
}

// MARK: - Fetch Businesses

private extension BusinessesListViewController {
    func requestData() {
        BusinessesFetcher.fetchBusinesses { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let businesses):
                self?.staticBusinessList = businesses
                self?.businesses = businesses
                self?.collectionView.reloadData()
            }
        }
    }
    
    func filterResults(with text: String) {
        businesses = staticBusinessList.filter {
            $0.name?.lowercased().contains(text.lowercased()) ?? false
        }
        collectionView.reloadData()
    }
    
    func clearResults() {
        businesses = staticBusinessList
        collectionView.reloadData()
    }
}
