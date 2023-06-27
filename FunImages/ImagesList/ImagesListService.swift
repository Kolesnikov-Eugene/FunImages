//
//  ImagesListService.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 27.06.2023.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    
    private var lastLoadedPage: Int?
    var photos: [Photo] = []
    
    private lazy var dateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    private init() { }
    
    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        if task != nil {
            task?.cancel()
        }
        guard let token = OAuth2TokenStorage.shared.token else { return }
        let request = imagesListRequest(token)
        
        let task = urlSession
            .object(for: request)
        { [weak self] (result: Result<PhotoResult, Error>) in // check if there is needed an array of PhotoResult ???
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let photoResult):
                    self.task = nil
                    let newPhoto = Photo(id: photoResult.id,
                                         size: CGSize(width: Double(photoResult.width), height: Double(photoResult.height)),
                                         createdAt: dateFormatter.date(from: photoResult.createdAt),
                                         welcomeDescription: photoResult.description,
                                         thumbImageUrl: photoResult.urls.thumb,
                                         largeImageUrl: photoResult.urls.full,
                                         isLiked: photoResult.likedByUser)
                    
                    photos.append(newPhoto)
                    
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": photoResult])
                case .failure(let error):
                    self.task = nil
                    print(error)
                }
            }
        }
        self.task = task
        task.resume()
    }
    //TODO implement parameter page! in HTTPRequest
    private func imagesListRequest(_ token: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/photos",
                                   httpMethod: "GET",
                                   baseURL: Constants.defaultBaseURL,
                                   tokenNeededForRequest: true)
    }
}
