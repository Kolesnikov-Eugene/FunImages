//
//  OAuthTokenResponseBody.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 30.05.2023.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
