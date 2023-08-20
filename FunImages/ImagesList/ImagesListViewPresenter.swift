//
//  ImagesListViewPresenter.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 19.08.2023.
//

import UIKit

protocol ImagesListViewPresenterProtocol {
    var imagesListView: ImagesListViewController? { get set }
    func fetchPhotosForNextPage()
    func didConfigure(_ cell: ImagesListCell, with indexPath: IndexPath)
    func getPhotosCount() -> Int
    func checkToFetchNextPage(for currentIndex: Int)
    func calculateHeightForCell(for tableViewWidth: CGFloat, at indexPath: IndexPath) -> CGFloat
    func didUpdateTableView()
    func didChangeLike(for cell: ImagesListCell ,at indexPath: IndexPath, _ completion: @escaping (Result<Void, Error>) -> Void)
    func getLargeImageURL(at indexPath: IndexPath) -> String
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    private var imagesListService = ImagesListService.shared
    private var photos: [Photo] = []
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    weak var imagesListView: ImagesListViewController?
    
    func fetchPhotosForNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func getPhotosCount() -> Int {
        photos = imagesListService.photos
        return photos.count
    }
    
    func didConfigure(_ cell: ImagesListCell, with indexPath: IndexPath) {
        let currentImage = photos[indexPath.row]
        guard let imageURL = URL(string: currentImage.thumbImageUrl) else {
            assertionFailure("unable to extract date")
            return
        }
        
        let dateText = getDateToDisplay(from: currentImage)
        
        let likeIsOn = currentImage.isLiked
        let cellLikeButttonImage = likeIsOn ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        
        let cellModel = ImageListCellModel(
            imageForCell: imageURL,
            dateLabelText: dateText,
            likeButtonImage: cellLikeButttonImage!)
        
        cell.configCell(with: cellModel)
    }
    
    func checkToFetchNextPage(for currentIndex: Int) {
        if currentIndex == imagesListService.photos.count {
            fetchPhotosForNextPage()
        }
    }
    
    func calculateHeightForCell(for tableViewWidth: CGFloat, at indexPath: IndexPath) -> CGFloat {
        let imageSize = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableViewWidth - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func didUpdateTableView() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount != newCount {
            imagesListView?.updateTableViewAnimated(oldCount, newCount)
        }
    }
    
    func didChangeLike(for cell: ImagesListCell, at indexPath: IndexPath, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let photo = photos[indexPath.row]
        imagesListService.changeLike(
            photoId: photo.id,
            isLiked: photo.isLiked) { result in
                switch result {
                case .success:
                    self.photos[indexPath.row] = self.imagesListService.photos[indexPath.row]
                    cell.changeLike(isLiked: self.photos[indexPath.row].isLiked)
                    
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure((error)))
                }
            }
    }
    
    func getLargeImageURL(at indexPath: IndexPath) -> String {
        let imageURLString = photos[indexPath.row].largeImageUrl
        return imageURLString
    }
    
    private func getDateToDisplay(from imageModel: Photo) -> String {
        guard let currentDate = imageModel.createdAt else {
            return ""
        }
        let dateText = dateFormatter.string(from: currentDate)
        return dateText
    }
}
