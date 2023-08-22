//
//  ImagesListViewPresenterSpy.swift
//  FunImagesTests
//
//  Created by Eugene Kolesnikov on 21.08.2023.
//

import Foundation
@testable import FunImages

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var imagesListView: FunImages.ImagesListViewControllerProtocol?
    var photosFetchedCalled = false
    
    func fetchPhotosForNextPage() {
        photosFetchedCalled = true
    }
    
    func didConfigure(_ cell: FunImages.ImagesListCell, with indexPath: IndexPath) {
    }
    
    func getPhotosCount() -> Int {
        return 1
    }
    
    func checkToFetchNextPage(for currentIndex: Int) {
    }
    
    func calculateHeightForCell(for tableViewWidth: CGFloat, at indexPath: IndexPath) -> CGFloat {
        return 1
    }
    
    func didUpdateTableView() {
    }
    
    func didChangeLike(for cell: FunImages.ImagesListCell, at indexPath: IndexPath, _ completion: @escaping (Result<Void, Error>) -> Void) {
    }
    
    func getLargeImageURL(at indexPath: IndexPath) -> String {
        return ""
    }
    
    
}
