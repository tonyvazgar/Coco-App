//
//  CocoCardsViewController.swift
//  Coco
//
//  Created by Carlos Banos on 2/19/21.
//  Copyright © 2021 Easycode. All rights reserved.
//

import UIKit

final class CocoCardsViewController: UIViewController {
    private var cocoCards: [CocoCard] = []
    private var loader = LoaderVC()
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var enterCodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        enterCodeButton.roundCorners(12)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    
    @IBAction private func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func enterCodeButtonAction(_ sender: Any) {
        let viewController = UIStoryboard.payments.instantiate(AddCocoCardViewController.self)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Configure Table

private extension CocoCardsViewController {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: MyCocoCardsTableViewCell.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MyCocoCardsTableViewCell.cellIdentifier)
    }
}

// MARK: - Table View

extension CocoCardsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cocoCards.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyCocoCardsTableViewCell.cellIdentifier, for: indexPath) as? MyCocoCardsTableViewCell else {
            return UITableViewCell()
        }

        let card = cocoCards[indexPath.row]
        cell.dateLabel.text = card.redemptionDate
        cell.codeLabel.text = card.token
        cell.amountLabel.text = "$ \(card.amount ?? "--")"
       
        return cell
    }
}

// MARK: - Fetch Cards

extension CocoCardsViewController {
    func requestData() {
        loader.showInView(aView: view, animated: true)
        PaymentMethodsFetcher.fetchCocoCards { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error):
                print(error)
            case .success(let cocoCards):
                self?.cocoCards = cocoCards
                self?.tableView.reloadData()
            }
        }
    }
}
