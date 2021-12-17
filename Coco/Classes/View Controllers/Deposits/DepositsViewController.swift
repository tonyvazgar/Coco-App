//
//  DepositsViewController.swift
//  Coco
//
//  Created by Carlos Banos on 11/9/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

class DepositsViewController: UIViewController {
    @IBOutlet private var topBar: UIView!
    @IBOutlet private var table: UITableView!
    
    private var loader: LoaderVC!
    private var deposits: [Deposit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        requestData()
    }
    
    @IBAction private func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Configure View

private extension DepositsViewController {
    private func configureTable() {
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        let nib = UINib(nibName: DepositsTableViewCell.cellIdentifier, bundle: nil)
        table.register(nib, forCellReuseIdentifier: DepositsTableViewCell.cellIdentifier)
    }
    
    private func requestData() {
        showLoader(&loader, view: view)
        PaymentMethodsFetcher.fetchDeposits { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self?.throwError(str: errorMssg.localizedDescription)
            case .success(let data):
                self?.deposits = data
                self?.table.reloadData()
            }
        }
    }
}

// MARK: - Table View Delegate

extension DepositsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deposits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DepositsTableViewCell.cellIdentifier, for: indexPath) as? DepositsTableViewCell else {
            return UITableViewCell()
        }
        let item = deposits[indexPath.row]
        cell.cardHolder.text = item.cardHolder
        cell.dateLabel.text = item.date
        cell.digitsLabel.text = item.digits
        cell.amountLabel.text = "$ " + (item.amount ?? "--")
        switch item.type {
        case "VISA":
            cell.typeView.image = #imageLiteral(resourceName: "visa_sola")
        case "MASTER CARD":
            cell.typeView.image = #imageLiteral(resourceName: "mastercard")
        case "AMEX":
            cell.typeView.image = #imageLiteral(resourceName: "amex")
        default:
            cell.typeView.image = #imageLiteral(resourceName: "credit_menu")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 202
    }
}
