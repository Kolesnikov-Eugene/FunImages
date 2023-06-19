//
//  ProfileService.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 13.06.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    var profileData: Profile?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private init() { }

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void ) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        
        let request = profileRequest(token)
        let task = urlSession.object(
            for: request)
        { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.task = nil
                profileData = Profile(
                    userName: profile.username,
                    name: "\(profile.firstName) \(profile.lastName)",
                    logName: "@\(profile.username)", bio: profile.bio)
                completion(.success(profileData!))
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
        self.task = task
        task.resume()
    }
    
    private func profileRequest(_ token: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/me_",
                                   httpMethod: "GET",
                                   baseURL: Constants.defaultBaseURL,
                                   tokenNeededForRequest: true)
    }
}

