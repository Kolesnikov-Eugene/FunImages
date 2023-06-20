//
//  OAuth2TokenStorage.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 05.06.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let keyChainWrapper = KeychainWrapper.standard
    private let tokenKey = "token"
    
    var token: String? {
        get {
            keyChainWrapper.string(forKey: tokenKey)
        }
        set {
            if let newValue = newValue {
                keyChainWrapper.set(newValue, forKey: tokenKey)
            }
        }
    }
    
    private init() { }
}
