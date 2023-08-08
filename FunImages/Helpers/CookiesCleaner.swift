//
//  CookiesCleaner.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 07.08.2023.
//

import Foundation
import WebKit

final class CookiesCleaner {
    static func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
