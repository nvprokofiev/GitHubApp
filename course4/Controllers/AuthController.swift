//
//  AuthController.swift
//  course4
//
//  Created by Nikolai Prokofev on 2019-03-27.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import Foundation

enum AuthResult {
    case success((username: String, password: String))
    case failed(Error)
}

class AuthController {
    private let serviceName = "course4app"
    private let biometricAuth = BiometricAuthentication()

    @discardableResult
    func store(_ username: String, _ password: String) -> Bool {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        query[kSecAttrService as String] = serviceName as AnyObject
        query[kSecAttrAccount as String] = username as AnyObject
        query[kSecValueData as String] = password.data(using: .utf8) as AnyObject
        
        if let storedCredentials = read() {
            if storedCredentials == (username, password) {
                var attributes = [String: Any]()
                attributes[kSecAttrAccount as String] = username
                attributes[kSecValueData as String] = password
                return SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == noErr
            }
        } else {
            return SecItemAdd(query as CFDictionary, nil) == noErr
        }
        return false
    }
    
    private func read() -> (username: String, password: String)? {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        query[kSecAttrService as String] = serviceName as AnyObject
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status != noErr {
            return nil
        }
        
        if let item = item as? [String: Any],
            let username = item[kSecAttrAccount as String] as? String,
            let passwordData = item[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8) {
            print("\(username) - \(password)")
            return (username, password)
        }
        return nil
    }
    
    func auth(_ completion: @escaping (AuthResult)->()){
        if let credentials = read() {
            biometricAuth.auth { error in
                if error == nil {
                    completion(.success(credentials))
                } else {
                    completion(.failed(error!))
                }
            }
        }
    }
}
