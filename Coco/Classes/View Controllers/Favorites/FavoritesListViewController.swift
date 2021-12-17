//
//  FavoritesListViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/18/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class FavoritesListViewController: UITableViewController {
    private var favorites: [FavoriteProduct] = []
    private var loader: LoaderVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        configureTableView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteProductTableViewCell.cellIdentifier, for: indexPath) as? FavoriteProductTableViewCell else {
            return UITableViewCell()
        }
        let item = favorites[indexPath.row]
        cell.delegate = self
        cell.productId = item.id_product
        cell.brandName.text = item.business
        cell.dishName.text = item.name
        cell.dishImage.kf.setImage(with: URL(string: item.imageURL ?? ""),
                                   placeholder: nil,
                                   options: [.transition(.fade(0.4))],
                                   progressBlock: nil) { (image, _, _, _) in
            if let image = image {
                let width = image.size.width
                let height = image.size.height
                
                if width > height {
                    cell.imageHeight.constant = (50 * height) / width
                    cell.layoutIfNeeded()
                } else if width < height {
                    cell.imageWidth.constant = (50 * width) / height
                    cell.layoutIfNeeded()
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let viewController = UIStoryboard.products.instantiate(ProductDetailViewControlller.self)
        viewController.productId = favorite.id_product
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Configure View

private extension FavoritesListViewController {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = .zero
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: FavoriteProductTableViewCell.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: FavoriteProductTableViewCell.cellIdentifier)
    }
}

// MARK: - Requests

private extension FavoritesListViewController {
    func requestData() {
        showLoader(&loader, view: view)
        ProductsFetcher.fetchFavorites { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self?.throwError(str: errorMssg.localizedDescription)
            case .success(let favorites):
                self?.favorites = favorites
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - Cell delegate

extension FavoritesListViewController: FavoriteProductCellDelegate {
    func didTapFavoriteAction(productId: String?) {
        guard let productId = productId else { return }
        ProductsFetcher.updateFavorite(id_product: productId, status: "1") { [weak self] result in
            switch result {
            case .failure(let errorMssg):
              self?.throwError(str: errorMssg)
            case .success(_):
              self?.showAlertMessage()
              self?.requestData()
            }
        }
    }
}

// MARK: - Alerts

private extension FavoritesListViewController {
    func showAlertMessage() {
        let alert = AlertModal()
        addChild(alert)
        alert.showInView(aView: view, text: "El producto ha sido eliminado de favoritos")
    }
}
