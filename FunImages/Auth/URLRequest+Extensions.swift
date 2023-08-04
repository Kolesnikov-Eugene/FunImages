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
        baseURL: URL = Constants.defaultBaseURL,
        tokenNeededForRequest: Bool
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        if tokenNeededForRequest {
            guard let token = OAuth2TokenStorage.shared.token else {
                assertionFailure("Unable to retrieve token from storage") // check if this is correct
                return request
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
