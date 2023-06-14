//
//  OAuth2Service.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 30.05.2023.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private var task: URLSessionTask?
    private var lastCode: String?
    private let urlSession = URLSession.shared
    private (set) var authToken: String? {
        get {
            OAuth2TokenStorage.shared.token
        }
        set {
            OAuth2TokenStorage.shared.token = newValue
        }
    }
    
    private init() { }
    
    func fetchAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                return
            }
        }
        else {
            if lastCode == code {
                return
            }
        }
        
        lastCode = code
        
        let request = authTokenRequest(code: code)
        
        let task = object(for: request) { [weak self] result in
            guard let self = self  else { return }
            switch result {
            case .success(let body):
                print(body.accessToken) //delete
                self.task = nil
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                self.lastCode = nil
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: Constants.urlForToken,
            tokenNeededForRequest: false
        )
    }
}

extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = SnakeCaseJSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result {
                    try decoder.decode(OAuthTokenResponseBody.self, from: data)
                }
            }
            completion(response)
        }
    }
}
