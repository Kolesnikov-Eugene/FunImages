//
//  ProfileImageService.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 14.06.2023.
//

import UIKit

final class ProfileImageService {
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private (set) var avatarURL: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        if task != nil {
            task?.cancel()
        }
        
        let request = imageURLRequest(for: username)
        let task = object(for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let profilePhotoURL):
                    print(profilePhotoURL.profileImage.small)
                    self.task = nil
                    self.avatarURL = profilePhotoURL.profileImage.small
                    completion(.success(self.avatarURL!))
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": profilePhotoURL])
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    private func imageURLRequest(for userName: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/users/\(userName)",
            httpMethod: "GET",
            tokenNeededForRequest: true)
    }
}

extension ProfileImageService {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<UserResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = SnakeCaseJSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<UserResult, Error> in
                Result {
                    try decoder.decode(UserResult.self, from: data)
                }
            }
            completion(response)
        }
    }
}
