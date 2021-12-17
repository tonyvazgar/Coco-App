//
//  CityUpdateViewController.swift
//  Coco
//
//  Created by Carlos Banos on 11/30/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import DropDown

class CityUpdateViewController: UIViewController {
    @IBOutlet private var backView: UIView!
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var cityContainerView: UIView!
    
    private var dropdown = DropDown()
    private var loader = LoaderVC()
    
    private var cities: [CityDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCities()
        
        backView.roundCorners(16)
    }
    
    @IBAction
    private func closeButtonAction(_ sender: Any) {
        removeAnimate()
    }
}

// MARK: - Public functions

extension CityUpdateViewController {
    func showInView(_ containerView: UIView) {
        containerView.addSubview(view)
        view.frame = CGRect(origin: .zero, size: containerView.bounds.size)
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0;
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion: { completed in
            if (completed) {
                self.view.removeFromSuperview()
            }
        })
    }
}

// MARK: - Configure

private extension CityUpdateViewController {
    func fetchCities() {
        loader.showInView(aView: view, animated: true)
        CitiesFetcher.fetchCities { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error):
                self?.throwError(str: error.localizedDescription)
            case .success(let cities):
                self?.cities = cities
                self?.configureDropdown()
            }
        }
    }
    
    func configureDropdown() {
        cityContainerView.addTap(#selector(openDropdown), tapHandler: self)
        dropdown.anchorView = cityContainerView
        dropdown.dataSource = cities.map { $0.name }
        dropdown.direction = .any
        dropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            self.updateCity(id_city: self.cities[index].id)
            self.cityLabel.text = item
        }
    }
    
    @objc func openDropdown() {
        dropdown.show()
    }
    
    func updateCity(id_city: String) {
        loader.showInView(aView: parent?.view, animated: true)
        CitiesFetcher.updateCity(id_city: id_city) { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let error):
                self?.throwError(str: error.localizedDescription)
            case .success:
                self?.removeAnimate()
            }
        }
    }
}
