//
//  SideMenuViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/7/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import Foundation

protocol SideMenuDelegate: AnyObject {
    func didSelectMenuOption(option: SideMenu)
}

final class SideMenuViewController: UIViewController {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var topBar: UIView!
    @IBOutlet private var table: UITableView!
    
    weak var delegate: SideMenuDelegate?
    let menuDataTable: [SideMenu] = [.orders, .favorite, .deposits, .help, .settings, .session]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        configureNameLabel()
    }
    
    private func configureNameLabel() {
        guard let user = UserManagement.shared.user else {
            nameLabel.text = nil
            return
        }
        
        let name = (user.name ?? "") + " " + (user.last_name ?? "")
        let email = user.email ?? ""
        nameLabel.text = name + "\n" + email
    }
    
    private func configureTable() {
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        
        let nib = UINib(nibName: SideMenuTableViewCell.cellIdentifier, bundle: nil)
        table.register(nib, forCellReuseIdentifier: SideMenuTableViewCell.cellIdentifier)
    }
    
    func showInView(aView: UIView!) {
        aView.addSubview(self.view)
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    @IBAction private func editUserAction(_ sender: Any) {
        delegate?.didSelectMenuOption(option: .profile)
    }
    
    @IBAction private func closeAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0.0
        }) { (val) in
            self.view.removeFromSuperview()
        }
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuDataTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.cellIdentifier, for: indexPath) as? SideMenuTableViewCell else {
            return UITableViewCell()
        }
        let item = menuDataTable[indexPath.row]
        
        cell.titleLabel.text = item.rawValue
        cell.iconImageView.image = item.getImage()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectMenuOption(option: menuDataTable[indexPath.row])
    }
}

extension SideMenuDelegate where Self: UIViewController {
    func didSelectMenuOption(option: SideMenu) {
        switch option {
        case .profile:
            let vc = UIStoryboard.profile.instantiate(ProfileViewController.self)
            presentAsync(vc)
        case .favorite:
            let vc = UIStoryboard.favorites.instantiate(FavoritesContainerViewController.self)
            let navigationController = UINavigationController(rootViewController: vc)
            presentAsync(navigationController)
        case .orders:
            let vc = UIStoryboard.orders.instantiate(OrdersContainerViewController.self)
            let navigationController = UINavigationController(rootViewController: vc)
            presentAsync(navigationController)
        case .settings:
            let vc = UIStoryboard.settings.instantiate(SettingsViewController.self)
            presentAsync(vc)
        case .deposits:
            let vc = UIStoryboard.deposits.instantiate(DepositsViewController.self)
            presentAsync(vc)
        case .help:
            let vc = UIStoryboard.help.instantiate(HelpViewController.self)
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        case .session:
            let refreshAlert = UIAlertController(title: "¿Cerrar sesión?",
                                                 message: "Si cierras sesión tendrás que volver a introducir tus credenciales.",
                                                 preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Cerrar Sesión", style: .destructive) { [weak self] _ in
                self?.sessionEnd()
            })
            refreshAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
}
