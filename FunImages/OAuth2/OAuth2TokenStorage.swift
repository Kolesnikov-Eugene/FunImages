//
//  OAuth2TokenStorage.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 05.06.2023.
//

import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let defaults = UserDefaults()
    private let tokenKey = "token"
    
    var token: String? {
        get {
            return defaults.string(forKey: tokenKey)
        }
        set {
            defaults.set(newValue, forKey: tokenKey)
        }
    }
    
    private init() { }
}
