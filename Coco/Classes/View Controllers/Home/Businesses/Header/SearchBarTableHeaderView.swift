//
//  SearchBarTableHeaderView.swift
//  Coco
//
//  Created by Carlos Banos on 11/25/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit

protocol SearchBarDelegate: AnyObject {
    func textDidChange(_: String)
    func textFieldShouldClear()
}

final class SearchBarTableHeaderView: UIView {
    @IBOutlet var backView: UIView!
    @IBOutlet var searchIcon: UIImageView!
    @IBOutlet var searchTextField: UITextField!
    
    weak var delegate: SearchBarDelegate?
    
    static func instantiate() -> Self {
        Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as! Self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange2), for: .editingChanged)
        
        backView.addTap(#selector(search), tapHandler: self)
    }
    
    @objc private func search() {
        searchTextField.becomeFirstResponder()
    }
    
    @objc private func textFieldDidChange2() {
        guard let text = searchTextField.text else { return }
        delegate?.textDidChange(text)
    }
    
    private func configureView() {
        backView.roundCorners(18)
        backView.addBorder(thickness: 1, color: .cocoGrayBorder)
    }
}

extension SearchBarTableHeaderView: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldClear()
        searchTextField.resignFirstResponder()
        return true
    }
}
