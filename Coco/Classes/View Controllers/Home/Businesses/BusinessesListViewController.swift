//
//  BusinessesListViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/8/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

final class BusinessesListViewController: UITableViewController {
    private(set) var staticBusinessList: [Business] = []
    private(set) var businesses: [Business] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        configureTableView()
        configureTableHeaderView()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
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
        return businesses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BusinessesTableViewCell.cellIdentifier, for: indexPath) as? BusinessesTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.row {
            case 0:
//                cell.downImage.image = UIImage(named: "beginningRoute.png")
                print("Soy la primera!")
            
                let business = businesses[indexPath.row]
                cell.businessName.text = business.name
                cell.businessAddress.text = "Próximamente"
                if let image = business.imgURL {
                    cell.businessImage.kf.setImage(with: URL(string: image),
                                                   placeholder: nil,
                                                   options: [.transition(.fade(0.4))],
                                                   progressBlock: nil,
                                                   completionHandler: nil)
                }
            
            // here we set the current date

                let date = NSDate()
                let calendar = Calendar.current

                let components = calendar.dateComponents([.hour, .minute, .month, .year, .day], from: date as Date)

                let currentDate = calendar.date(from: components)

                let userCalendar = Calendar.current

                // here we set the due date. When the timer is supposed to finish
                let competitionDate = NSDateComponents()
                competitionDate.year = 2022
                competitionDate.month = 2
                competitionDate.day = 16
                competitionDate.hour = 00
                competitionDate.minute = 00
                let competitionDay = userCalendar.date(from: competitionDate as DateComponents)!

                //here we change the seconds to hours,minutes and days
                let CompetitionDayDifference = calendar.dateComponents([.day, .hour, .minute], from: currentDate!, to: competitionDay)


                //finally, here we set the variable to our remaining time
                let daysLeft = CompetitionDayDifference.day
                let hoursLeft = CompetitionDayDifference.hour
                let minutesLeft = CompetitionDayDifference.minute

                print("day:", daysLeft ?? "N/A", "hour:", hoursLeft ?? "N/A", "minute:", minutesLeft ?? "N/A")

                //Set countdown label text
                cell.businessDistanceLabel.text = "Faltan \(daysLeft ?? 0) días, \(hoursLeft ?? 0) horas y \(minutesLeft ?? 0) minutos!"
//                countDownLabel.text = "\(daysLeft ?? 0) Days, \(hoursLeft ?? 0) Hours, \(minutesLeft ?? 0) Minutes"
            

            case self.tableView(tableView, numberOfRowsInSection: 0) - 1:
//                cell.downImage.image = UIImage(named: "endRoute.png")
                print("Soy la ultima!")
            
                let business = businesses[indexPath.row]
                cell.businessName.text = business.name
                cell.businessAddress.text = business.address
                cell.businessDistanceLabel.text = business.distance
                if let image = business.imgURL {
                    cell.businessImage.kf.setImage(with: URL(string: image),
                                                   placeholder: nil,
                                                   options: [.transition(.fade(0.4))],
                                                   progressBlock: nil,
                                                   completionHandler: nil)
                }

            default:
//                cell.downImage.image = nil
                print("Soy la intermedia!")
                
                let business = businesses[indexPath.row]
                cell.businessName.text = business.name
                cell.businessAddress.text = business.address
                cell.businessDistanceLabel.text = business.distance
                if let image = business.imgURL {
                    cell.businessImage.kf.setImage(with: URL(string: image),
                                                   placeholder: nil,
                                                   options: [.transition(.fade(0.4))],
                                                   progressBlock: nil,
                                                   completionHandler: nil)
                }
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width/2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != 0 ){
            let business = businesses[indexPath.row]
            let viewController = UIStoryboard.home.instantiate(LocationsContainerViewController.self)
            viewController.businessId = business.id
            navigationController?.pushViewController(viewController, animated: true)
        }else{
            let business = businesses[indexPath.row]
            let viewController = UIStoryboard.home.instantiate(CounterViewController.self)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - Configure Table

private extension BusinessesListViewController {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: BusinessesTableViewCell.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: BusinessesTableViewCell.cellIdentifier)
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
                self?.tableView.reloadData()
            }
        }
    }
    
    func filterResults(with text: String) {
        businesses = staticBusinessList.filter {
            $0.name?.lowercased().contains(text.lowercased()) ?? false
        }
        tableView.reloadData()
    }
    
    func clearResults() {
        businesses = staticBusinessList
        tableView.reloadData()
    }
}
