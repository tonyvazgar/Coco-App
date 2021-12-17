//
//  ProfileViewController.swift
//  Coco
//
//  Created by Carlos Banos on 10/18/20.
//  Copyright © 2020 Easycode. All rights reserved.
//

import UIKit
import YPImagePicker
import SkyFloatingLabelTextField

class ProfileViewController: UIViewController {
    @IBOutlet private var topBar: UIView!
    @IBOutlet private var userImageView: UIImageView!
    @IBOutlet private var nameLabel: SkyFloatingLabelTextField!
    @IBOutlet private var lastNameLabel: SkyFloatingLabelTextField!
    @IBOutlet private var phoneLabel: SkyFloatingLabelTextField!
    @IBOutlet private var passwordLabel: SkyFloatingLabelTextField!
    @IBOutlet private var saveButton: UIButton!
    
    var userProfile: UserProfile!
    var loader: LoaderVC!
    
    private var imageChange: Bool = false
    private var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        requestData()
    }
    
    @IBAction private func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func saveAction(_ sender: Any) {
        if imageChange {
            requestUpdateFullProfile()
        } else {
            requestUpdateUserInfo()
        }
    }
    
    @objc
    private func updateImage() {
        let picker = YPImagePicker(configuration: General.configurationImagePicker())
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.userImageView.image = photo.image
                self.image = photo.image
                self.imageChange = true
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
}

// MARK: - Configure View

private extension ProfileViewController {
    func configureView() {
        saveButton.roundCorners(15)
        userImageView.addTap(#selector(updateImage), tapHandler: self)
        nameLabel.titleFormatter = { $0.capitalized }
        lastNameLabel.titleFormatter = { $0.capitalized }
        phoneLabel.titleFormatter = { $0.capitalized }
    }
    
    func fillInfo() {
        nameLabel.text = userProfile.name
        lastNameLabel.text = userProfile.last_name
        phoneLabel.text = userProfile.phone
        guard let image = userProfile.imgURL, image != "null" else { return }
        userImageView.kf.setImage(with: URL(string: image),
                                  placeholder: nil,
                                  options: [.transition(.fade(0.4))],
                                  progressBlock: nil,
                                  completionHandler: nil)
        userImageView.circleBorders()
        userImageView.contentMode = .scaleAspectFill
    }
}

// MARK: - Request

private extension ProfileViewController {
    func requestData() {
        showLoader(&loader, view: view)
        userProfile = UserProfile()
        userProfile.requestUserInfo { result in
            self.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self.throwError(str: errorMssg)
            case .success(_):
                self.fillInfo()
            }
        }
    }
    
    func requestUpdateUserInfo() {
        userProfile.name = nameLabel.text
        userProfile.last_name = lastNameLabel.text
        userProfile.phone = phoneLabel.text
        userProfile.password = passwordLabel.text
        
        showLoader(&loader, view: view)
        userProfile.requestUpdateUserInfo { [weak self] (result) in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self?.throwError(str: errorMssg)
            case .success(_):
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func requestUpdateFullProfile() {
        userProfile.name = nameLabel.text
        userProfile.last_name = lastNameLabel.text
        userProfile.phone = phoneLabel.text
        userProfile.password = passwordLabel.text
        
        let imageData: Data = image.jpegData(compressionQuality: 0.75)!
        userProfile.imageBase64 = imageData.base64EncodedString()
        
        showLoader(&loader, view: view)
        userProfile.requestUpdateUserImage { [weak self] result in
            self?.loader.removeAnimate()
            switch result {
            case .failure(let errorMssg):
                self?.throwError(str: errorMssg)
            case .success(_):
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
