//
//  BiometricAuthentication.swift
//  course4
//
//  Created by Nikolai Prokofev on 2019-03-27.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import Foundation
import LocalAuthentication

class BiometricAuthentication {
    private let context = LAContext()
    private let reason = "It's safe way to auth"
    
    private enum BiometryType {
        case none
        case faceId
        case touchId
    }
    
    private func canEvaluatePolicy() -> Bool{
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    private func biometryType() -> BiometryType {
        if !canEvaluatePolicy() {
            return .none
        }
        
        switch context.biometryType {
        case .none:
            return .none
        case .faceID:
            return .faceId
        case .touchID:
            return .touchId
        }
    }
    
    func auth(_ completion: @escaping (Error?)->()) {
        guard canEvaluatePolicy() else {
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
    }
}
