//
//  OAuth2TokenStorage.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 05.06.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private let defaults = UserDefaults()
    
    var token: String? {
        get {
            return defaults.string(forKey: "token")
        }
        set {
            defaults.set(newValue, forKey: "token")
        }
    }
}
