//
//  ProfileVC.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import UIKit
import YPImagePicker
import SkyFloatingLabelTextField

class ProfileVC: UIViewController {

  @IBOutlet weak var topBar: UIView!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var nameLabel: SkyFloatingLabelTextField!
  @IBOutlet weak var lastNameLabel: SkyFloatingLabelTextField!
  @IBOutlet weak var phoneLabel: SkyFloatingLabelTextField!
  @IBOutlet weak var saveButton: UIButton!
  
  var userProfile: UserProfile!
  var loader: LoaderVC!
  
  private var imageChange: Bool = false
  private var image: UIImage!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    requestData()
  }
  
  private func configureView() {
    saveButton.roundCorners(15)
    userImageView.addTap(#selector(updateImage), tapHandler: self)
  }
  
  private func requestData() {
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
  
  private func fillInfo() {
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
  
  @IBAction func backBtn(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func saveAction(_ sender: Any) {
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
  
  private func requestUpdateUserInfo() {
    userProfile.name = nameLabel.text
    userProfile.last_name = lastNameLabel.text
    userProfile.phone = phoneLabel.text
    
    showLoader(&loader, view: view)
    userProfile.requestUpdateUserInfo { (result) in
      self.loader.removeAnimate()
      switch result {
      case .failure(let errorMssg):
        self.throwError(str: errorMssg)
      case .success(_):
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  private func requestUpdateFullProfile() {
    userProfile.name = nameLabel.text
    userProfile.last_name = lastNameLabel.text
    userProfile.phone = phoneLabel.text
    let imageData: Data = image.jpegData(compressionQuality: 0.75)!
    userProfile.imageBase64 = imageData.base64EncodedString()

    showLoader(&loader, view: view)
    userProfile.requestUpdateUserImage { (result) in
      self.loader.removeAnimate()
      switch result {
      case .failure(let errorMssg):
        self.throwError(str: errorMssg)
      case .success(_):
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
}
