//
//  User.swift
//  Coco
//
//  Created by Carlos Banos on 7/1/19.
//  Copyright © 2019 Easycode. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Darwin

class User: Decodable {
    
    var user: User!
    
    public var id: String?
    public var name: String?
    public var last_name: String?
    public var phone: String?
    public var email: String?
    public var password: String?
    public var facebook_login: Bool?
    public var imgURL: String?
    public var id_school: String?
    
    public init(id: String = "",
                name: String = "",
                last_name: String = "",
                phone: String = "",
                email: String = "",
                password: String = "",
                facebook_login: Bool = false,
                imgURL: String = "",
                id_school: String = "") {
        self.id = id
        self.name = name
        self.last_name = last_name
        self.phone = phone
        self.email = email
        self.password = password
        self.facebook_login = facebook_login
        self.imgURL = imgURL
        self.id_school = id_school
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id_user"
        case name = "first_name"
        case last_name = "last_name"
        case email
        case password
        case phone
        case facebook_login
        case imgURL = "imagen"
    }
    
    func loginRequest(completion: @escaping(Result) -> Void) {
        let data = [
            "funcion": Routes.login,
            "email": email ?? "",
            "password": password ?? ""]
        
        Alamofire.request(General.endpoint, method: .post, parameters: data).responseData { (response) in
            print("--------------------------------------------")
            print(data)
            print("--------------------------------------------")
            print(response)
            print("--------------------------------------------")
            guard let data = response.result.value else {
                completion(.failure("Error de conexión"))
                return
            }
            
            guard let dictionary = JSON(data).dictionary else {
                completion(.failure("Error al obtener los datos"))
                return
            }
            
            if dictionary["state"] != "200" {
                completion(.failure(dictionary["status_msg"]?.string ?? ""))
                return
            }
            
            guard let dataDictionary = dictionary["data"],
                  let object = try? dataDictionary.rawData(),
                  let decoded = try? JSONDecoder().decode(User.self, from: object) else {
                completion(.failure("Error al leer los datos"))
                return
            }
            self.id = decoded.id
            self.email = decoded.email
            self.name = decoded.name
            self.last_name = decoded.last_name
            
            UserDefaults.standard.set(self.id, forKey: "id_user")
            UserDefaults.standard.set(self.email, forKey: "email_user")
            completion(.success(nil))
        }
    }
    
    func loginRequestFromApple(completion: @escaping(Result) -> Void) {
        let data = [
            "funcion": Routes.login,
            "email": email ?? "",
            "password": password ?? "",
            "apple_sign_in": true
        ] as [String : Any]
        
        Alamofire.request(General.endpoint, method: .post, parameters: data).responseData { (response) in
            guard let data = response.result.value else {
                completion(.failure("Error de conexión"))
                return
            }
            
            guard let dictionary = JSON(data).dictionary else {
                completion(.failure("Error al obtener los datos"))
                return
            }
            
            if dictionary["state"] != "200" {
                completion(.failure(dictionary["status_msg"]?.string ?? ""))
                return
            }
            
            guard let dataDictionary = dictionary["data"],
                  let object = try? dataDictionary.rawData(),
                  let decoded = try? JSONDecoder().decode(User.self, from: object) else {
                completion(.failure("Error al leer los datos"))
                return
            }
            self.id = decoded.id
            self.email = decoded.email
            self.name = decoded.name
            self.last_name = decoded.last_name
            
            UserDefaults.standard.set(self.id, forKey: "id_user")
            completion(.success(nil))
        }
    }
    
    func newUserRequest(id_city: String = "", completion: @escaping(Result) -> Void) {
        let data = [
            "funcion": Routes.newUser,
            "first_name": name ?? "",
            "last_name": last_name ?? "",
            "phone": phone ?? "",
            "email": email ?? "",
            "password": password ?? "",
            "facebook_login": facebook_login ?? false,
            "city": id_city] as [String : Any]
        
        Alamofire.request(General.endpoint, method: .post, parameters: data).responseData { (response) in
            print("--------------------------------------------")
            print(data)
            
            guard let data = response.result.value else {
                completion(.failure("Error de conexión"))
                return
            }
            
            guard let dictionary = JSON(data).dictionary else {
                completion(.failure("Error al obtener los datos"))
                return
            }
            
            if dictionary["state"] != "200" {
                completion(.failure(dictionary["status_msg"]?.string ?? ""))
                return
            }
            
            guard let dataDictionary = dictionary["data"],
                  let object = try? dataDictionary.rawData(),
                  let decoded = try? JSONDecoder().decode(User.self, from: object) else {
                completion(.failure("Error al leer los datos"))
                return
            }
            
            print("--------------------------------------------")
            print(String(describing: decoded))
            print("--------------------------------------------")
            self.id = decoded.id
            self.email = decoded.email
            self.name = decoded.name
            self.last_name = decoded.last_name
            completion(.success(nil))
        }
    }
    
    func newUserRequest2(completion: @escaping(Result) -> Void) {
        let data = [
            "funcion": Routes.newUser,
            "first_name": name ?? "",
            "last_name": last_name ?? "",
            "phone": phone ?? "",
            "email": email ?? "",
            "password": password ?? "",
            "facebook_login": "2",
            "id_college": id_school ?? ""] as [String : Any]
        print(data)
        Alamofire.request(General.url_connection,
                          method: .post,
                          parameters: data).responseJSON { (response) in
                            guard let data = response.result.value else {
                                completion(.failure("Error de conexión"))
                                return
                            }
                            
                            guard let dictionary = JSON(data).dictionary else {
                                completion(.failure("Error al obtener los datos"))
                                return
                            }
                            
                            print("This is the data I'm tryuing to get out")
                            print(data)
                            print("***************************************")
                            
                            if dictionary["state"] != "200" {
                                completion(.failure(dictionary["status_msg"]?.string ?? ""))
                                return
                            }
                            
                            guard let dataDictionary = dictionary["data"],
                                  let object = try? dataDictionary.rawData(),
                                  let decoded = try? JSONDecoder().decode(User.self, from: object) else {
                                completion(.failure("Error al leer los datos"))
                                return
                            }
                            self.id = decoded.id
                            self.email = decoded.email
                            self.name = decoded.name
                            self.last_name = decoded.last_name
                            completion(.success(nil))
                          }
    }
    
    func forgotPasswordRequest(completion: @escaping(Result) -> Void) {
        let data = [
            "funcion": Routes.recoverAccount,
            "email": email ?? ""] as [String : Any]
        
        Alamofire.request(General.url_connection, method: .post, parameters: data).responseJSON { (response) in
            guard let data = response.result.value else {
                completion(.failure("Error de conexión"))
                return
            }
            
            guard let dictionary = JSON(data).dictionary else {
                completion(.failure("Error al obtener los datos"))
                return
            }
            
            if dictionary["state"] != "200" {
                completion(.failure(dictionary["status_msg"]?.string ?? ""))
                return
            }
            
            completion(.success(nil))
        }
    }
}

class UserProfile: Decodable {
    public var name: String?
    public var last_name: String?
    public var phone: String?
    public var password: String?
    public var imgURL: String?
    public var imageBase64: String?
    
    public init(name: String = "",
                last_name: String = "",
                phone: String = "",
                imgURL: String = "",
                imageBase64: String = "") {
        self.name = name
        self.last_name = last_name
        self.phone = last_name
        self.imgURL = imgURL
        self.imageBase64 = imageBase64
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "nombre"
        case last_name = "apellidos"
        case phone = "telefono"
        case imgURL = "imagen"
    }
    
    func requestUserInfo(completion: @escaping(Result) -> Void) {
        let data = [
            "funcion": Routes.getUserInfo,
            "id_user": UserManagement.shared.id_user!,
        ]
        
        Alamofire.request(General.endpoint, method: .post, parameters: data).responseJSON { (response) in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
            guard let data = response.result.value else {
                completion(.failure("Error de conexión"))
                return
            }
            
            guard let dictionary = JSON(data).dictionary else {
                completion(.failure("Error al obtener los datos"))
                return
            }
            
            if dictionary["state"] != "200" {
                completion(.failure(dictionary["status_msg"]?.string ?? ""))
                return
            }
            guard let dataDictionary = dictionary["data"],
                  let object = try? dataDictionary["info"].rawData(),
                  let decoded = try? JSONDecoder().decode(UserProfile.self, from: object) else {
                completion(.failure("Error al leer los datos"))
                return
            }
            self.name = decoded.name
            self.last_name = decoded.last_name
            self.phone = decoded.phone
            self.imgURL = decoded.imgURL
            completion(.success([]))
        }
    }
    
    func requestUpdateUserInfo(completion: @escaping(Result) -> Void) {
        let data = [
            "funcion": Routes.updateUserIOS,
            "id_user": UserManagement.shared.id_user!,
            "first_name": name ?? "",
            "last_name": last_name ?? "",
            "phone": phone ?? "",
            "password": password ?? "",
        ]
        
        Alamofire.request(General.endpoint, method: .post, parameters: data).responseJSON { (response) in
            guard let data = response.result.value else {
                completion(.failure("Error de conexión"))
                return
            }
            
            guard let dictionary = JSON(data).dictionary else {
                completion(.failure("Error al obtener los datos"))
                return
            }
            
            if dictionary["state"] != "200" {
                completion(.failure(dictionary["status_msg"]?.string ?? ""))
                return
            }
            completion(.success([]))
        }
    }
    
    func requestUpdateUserImage(completion: @escaping(Result) -> Void) {
        let data = [
            "funcion": Routes.updateUserIOS,
            "id_user": UserManagement.shared.id_user!,
            "first_name": name ?? "",
            "last_name": last_name ?? "",
            "phone": phone ?? "",
            "password": password ?? "",
            "image": imageBase64 ?? ""
        ]
        
        Alamofire.request(General.endpoint, method: .post, parameters: data).responseJSON { (response) in
            guard let data = response.result.value else {
                completion(.failure("Error de conexión"))
                return
            }
            
            guard let dictionary = JSON(data).dictionary else {
                completion(.failure("Error al obtener los datos"))
                return
            }
            
            if dictionary["state"] != "200" {
                completion(.failure(dictionary["status_msg"]?.string ?? ""))
                return
            }
            
            completion(.success([]))
        }
    }
}


