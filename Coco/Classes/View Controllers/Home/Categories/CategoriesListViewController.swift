//
//  CategoriesListViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/9/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class CategoriesListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private(set) var categories: [Category] = []
    private var loader = LoaderVC()
    var businessId: String?
    var locationId: String?
    var location: LocationsDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        configureCollectionView()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { categories.count }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.cellIdentifier, for: indexPath) as? CategoryCollectionViewCell else {
            return CategoryCollectionViewCell()
        }
        
        let category = categories[indexPath.row]
        
        cell.categoryLabel.text = category.name
        if let image = category.imageURL {
            cell.categoryImage.kf.setImage(with: URL(string: image),
                                           placeholder: nil,
                                           options: [.transition(.fade(0.4))],
                                           progressBlock: nil,
                                           completionHandler: nil)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let viewController = UIStoryboard.products.instantiate(ProductsContainerViewController.self)
        viewController.businessId = businessId
        viewController.locationId = locationId
        viewController.categoryId = category.id
        viewController.location = location
        navigationController?.pushViewController(viewController, animated: true)
    }
}


// MARK: - Configure Table

private extension CategoriesListViewController {
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = false
        
        collectionView.backgroundColor = .clear
        
        let nib = UINib(nibName: CategoryCollectionViewCell.cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: CategoryCollectionViewCell.cellIdentifier)
    }
}

// MARK: - Fetch Businesses

private extension CategoriesListViewController {
    func requestData() {
        guard let locationId = locationId else { return }
        print(locationId)
        loader.showInView(aView: view, animated: true)
        CategoriesFetcher.fetchCategories(locationId: locationId) { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error):
                print(error)
            case .success(let categories):
                self?.categories = categories
                self?.collectionView.reloadData()
            }
        }
    }
}
