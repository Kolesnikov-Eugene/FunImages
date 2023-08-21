//
//  ImagesListViewTests.swift
//  FunImagesTests
//
//  Created by Eugene Kolesnikov on 21.08.2023.
//

import XCTest
@testable import FunImages

final class ImagesListViewTests: XCTestCase {
    func testImagesListPresenterFetchedPhotos() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListViewPresenterSpy()
        viewController.configure(presenter)
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.photosFetchedCalled)
    }
    
    func testPhotosCount() {
        //given
        let tableView = UITableView()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListViewPresenterSpy()
        viewController.configure(presenter)
        
        //when
        let count = viewController.tableView(tableView, numberOfRowsInSection: 0)
        
        //then
        XCTAssertEqual(count, 1)
    }
}
