//
//  FavoritesVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {

  @IBOutlet weak var topBar: UIView!
  @IBOutlet weak var table: UITableView!
  
  var loader: LoaderVC!
  var favorites: Favorites!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    favorites = Favorites()
    configureTable()
    requestData()
  }
  
  private func configureTable() {
    table.separatorStyle = .none
    table.delegate = self
    table.dataSource = self
    table.tableFooterView = UIView()
    let nib = UINib(nibName: FavoritesTableViewCell.cellIdentifier, bundle: nil)
    table.register(nib, forCellReuseIdentifier: FavoritesTableViewCell.cellIdentifier)
  }
  
  private func requestData() {
    showLoader(&loader, view: view)
    favorites.requestFavorites { result in
      self.loader.removeAnimate()
      switch result {
      case .failure(let errorMssg):
        self.throwError(str: errorMssg)
      case .success(_):
        self.fillInfo()
      }
    }
  }
  
  private func fillInfo() {
    table.reloadData()
  }
  
  @IBAction func closeBtn(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favorites.favorites.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.cellIdentifier, for: indexPath) as? FavoritesTableViewCell else {
      return UITableViewCell()
    }
    let item = favorites.favorites[indexPath.row]
    cell.delegate = self
    cell.brandName.text = item.business
    cell.dishName.text = item.name
    cell.dishImage.kf.setImage(with: URL(string: item.imageURL ?? ""),
                               placeholder: nil,
                               options: [.transition(.fade(0.4))],
                               progressBlock: nil,
                               completionHandler: nil)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = favorites.favorites[indexPath.row]
    let product = Product(id: item.id_product ?? "")
    let vc = instantiate(viewControllerClass: ProductDetailVC.self, storyBoardName: "Main")
    vc.product = product
    presentAsync(vc)
  }
}

extension FavoritesVC: FavoriteCellDelegate {
  func didTapFavoriteAction(index: Int) {
    showLoader(&loader, view: view)
    favorites.favorites[index].requestStatusFavorite(status: "1") { result in
      self.loader.removeAnimate()
      switch result {
      case .failure(let errorMssg):
        self.throwError(str: errorMssg)
      case .success(_):
        self.showAlertMessage()
        self.requestData()
      }
    }
  }
  
  private func showAlertMessage() {
    let alert = AlertModal()
    addChild(alert)
    alert.showInView(aView: view, text: "El producto ha sido eliminado de favoritos")
  }
}
