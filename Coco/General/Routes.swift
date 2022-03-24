//
//  Routes.swift
//  Coco
//
//  Created by Carlos Banos on 6/18/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

struct Routes {
    static let login = "login"
    static let loginGoogle = "loginGoogle"
    static let loginApple = "loginApple"
    static let newUser = "newUser"
    static let getMainData = "getUserMain"
    
    /** V2 */
    static let getBusinessesList = "getEstablishment"
    static let getLocationsList = "getStore"
    static let getCategories = "getCategories"
    static let getProducts = "getProductStore"
    static let getProductDetail = "getProductDetail"
    
    static let getCities = "getCities"
    static let updateCity = "updateCity"
    
    static let updateUserIOS = "updateUserIOS"
    static let getFavorites = "getFavorites"
    static let getOrders = "getOrders"
    static let getPayments = "getPayments"
    static let getCocoCards = "getCocoCards"
    static let redeemCocoCard = "ChangeFolioCocoCard"
    static let deleteCard = "deleteCard"
    static let ya_llegue = "ya_llegue"
    static let sendValoration = "sendValoration"
    
    static let getSchools = "getColleges"
    
    static let getTokens = "getTokens"
    static let addCard = "saveBalance"
    static let quitTokensUser = "quitTokensUser"
    
    
    
    static let recoverAccount = "recoverAccount"
    static let getUserInfo = "getUserInfo"
    static let newAddress = "newAddress"
    static let getAddress = "getAddress"
    static let quitAddressUser = "quitAddressUser"
    static let addTokensUser = "addTokensUser"
    
    static let updateNotifications = "updateNotifications"
    static let getSaucer = "getSaucer"
    static let getSaucerDetail = "getSaucerDetail"
    
    static let getOrdersDetail = "getOrderDetail"
    static let saveOrder = "saveOrderNew"
    static let saveOrderCocopoints = "saveOrderCocopoints"
    static let adminFavorite = "adminFavorite"
    
    static let sendToken = "sendToken"
    
    /** 2022 */
    static let getCodeVerification = "getCodeVerification"
    
    static let addCardV2 = "addNewCard"
}

