//
//  URLRequestExtension.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 05.06.2023.
//

import Foundation

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = Constants.defaultBaseURL
    ) -> URLRequest {
        let token = OAuth2TokenStorage.shared.token!
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
