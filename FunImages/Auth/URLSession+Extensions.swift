//
//  URLSession+.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 05.06.2023.
//

import Foundation

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
            let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            let task = dataTask(with: request) {data, response, error in
                if let error = error {
                    fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
                }
                else if let data = data,
                        let response = response,
                        let statusCode = (response as? HTTPURLResponse)?.statusCode
                {
                    if 200..<300 ~= statusCode {
                        fulfillCompletion(.success(data))
                        print(String(data: data, encoding: .utf8) as Any)
                    } else {
                        fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                } else {
                    fulfillCompletion(.failure(NetworkError.urlSessionError))
                }
            }
            task.resume()
            return task
        }
}