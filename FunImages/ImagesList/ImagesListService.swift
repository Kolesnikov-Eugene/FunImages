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
    private var likeTask: URLSessionTask?
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
        
        lastLoadedPage = nextPage
        
        if task != nil {
            task?.cancel()
        }
        guard let token = OAuth2TokenStorage.shared.token else {
            assertionFailure("No token in ImagesListService")
            return
        }
        let request = imagesListRequest(token)
        
        let task = urlSession
            .object(for: request)
        { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let photoResult):
                    self.task = nil
                    photos += photoResult.map {
                        Photo(
                        id: $0.id,
                        size: CGSize(width: Double($0.width), height: Double($0.height)),
                        createdAt: self.dateFormatter.date(from: $0.createdAt),
                        welcomeDescription: $0.description,
                        thumbImageUrl: $0.urls.thumb,
                        largeImageUrl: $0.urls.full,
                        isLiked: $0.likedByUser
                    )
                    }
                    
                    lastLoadedPage = nextPage + 1
                    
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": photos])
                case .failure(_):
                    self.task = nil
                    break
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        if likeTask != nil {
            likeTask?.cancel()
        }
        
        let httpMethodForLike = isLiked ? "DELETE" : "POST"
        
        guard let token = OAuth2TokenStorage.shared.token else { return }
        let request = setLikeRequest(token, photoID: photoId, httpMethod: httpMethodForLike)
        
        let likeTask = urlSession
            .object(for: request)
        { [weak self] (result: Result<LikeUpdateResult, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.likeTask = nil
                    if let index = self.photos.firstIndex(where: {$0.id == photoId}) {
                        let photo = self.photos[index]
                        
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageUrl: photo.thumbImageUrl,
                            largeImageUrl: photo.largeImageUrl,
                            isLiked: !isLiked
                        )
                        
                        self.photos[index] = newPhoto
                        completion(.success(()))
                    }
                case .failure:
                    self.likeTask = nil
                    assertionFailure("Unable to update like")
                }
            }
        }
        self.likeTask = likeTask
        likeTask.resume()
    }
    private func imagesListRequest(_ token: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/photos"
                                   + "?page=\(lastLoadedPage!)",
                                   httpMethod: "GET",
                                   baseURL: DefaultBaseURL,
                                   tokenNeededForRequest: true)
    }
    
    private func setLikeRequest(_ token: String, photoID: String, httpMethod: String) -> URLRequest {
        URLRequest.makeHTTPRequest(path: "/photos/\(photoID)/like",
                                   httpMethod: httpMethod,
                                   tokenNeededForRequest: true)
    }
}
