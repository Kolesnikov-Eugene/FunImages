//
//  OAuth2TokenStorage.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 05.06.2023.
//

import Foundation
import SwiftKeychainWrapper
import WebKit

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
    
    static func clean() {
        // Очищаем все куки из хранилища.
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища.
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища.
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    func deleteToken() {
        keyChainWrapper.removeObject(forKey: tokenKey)
    }
}
