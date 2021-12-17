//
//  MenuVC.swift
//  Coco
//
//  Created by Carlos Banos on 6/19/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit

protocol MenuDelegate: AnyObject {
    func didSelectMenuOption(option: Menu)
}

class MenuVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var table: UITableView!
    
    var delegate: MenuDelegate!
    
    let menuDataTable: [Menu] = [.profile, .balance, .cocopoints, .favorite, .orders, .settings, .session]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
    }
    
    private func configureTable() {
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        let nib = UINib(nibName: MenuTableViewCell.cellIdentifier, bundle: nil)
        table.register(nib, forCellReuseIdentifier: MenuTableViewCell.cellIdentifier)
    }
    
    func showInView(aView: UIView!, userName: String = "") {
        aView.addSubview(self.view)
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0
        nameLabel.text = userName
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    @IBAction func closeAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0.0
        }) { (val) in
            self.view.removeFromSuperview()
        }
    }
}

extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuDataTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.cellIdentifier, for: indexPath) as? MenuTableViewCell else {
            return UITableViewCell()
        }
        let item = menuDataTable[indexPath.row]
        
        cell.titleLabel.text = item.rawValue
        cell.iconImageView.image = item.getImage()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectMenuOption(option: menuDataTable[indexPath.row])
    }
    
}
