//
//  ViewController.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 01.05.2023.
//

import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    var imagesListViewPresenter: ImagesListViewPresenter? { get set }
    func updateTableViewAnimated(_ oldCount: Int, _ newCount: Int)
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    @IBOutlet private weak var tableView: UITableView!
    
    private let showSingleImageViewIdentifier = "ShowSingleImage"
    private var imagesListServiceObserver: NSObjectProtocol?
    private let progressHUD = UIBlockingProgressHUD.shared
    
    var imagesListViewPresenter: ImagesListViewPresenter?
      
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imagesListViewPresenter?.fetchPhotosForNextPage()
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main,
                using: { [ weak self ] _ in
                    self?.imagesListViewPresenter?.didUpdateTableView()
                })
    }
    
    func configure(_ presenter: ImagesListViewPresenterProtocol) {
        self.imagesListViewPresenter = presenter as? ImagesListViewPresenter
        imagesListViewPresenter?.imagesListView = self
    }
}

// MARK: - TableView Data Source
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let imagesListViewPresenter = imagesListViewPresenter else { return 0 }
        return imagesListViewPresenter.getPhotosCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imagesListViewPresenter?.didConfigure(imageListCell, with: indexPath)
        
        imageListCell.addGradientIfNeeded()
        
        imageListCell.delegate = self
        
        return imageListCell
    }
}

// MARK: - TableView Delegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath
    ) {
        let currentIndex = indexPath.row + 1
        
        imagesListViewPresenter?.checkToFetchNextPage(for: currentIndex)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageViewIdentifier, sender: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        UIBlockingProgressHUD.show()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewWidth = tableView.bounds.width
        
        guard let imagesListViewPresenter = imagesListViewPresenter else { return 0 }
        
        let cellHeight = imagesListViewPresenter.calculateHeightForCell(for: tableViewWidth ,at: indexPath)
        
        return cellHeight
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageViewIdentifier {
            if let destinationVC = segue.destination as? SingleImageViewController,
            let imagesListViewPresenter = imagesListViewPresenter {
                let indexPath = tableView.indexPathForSelectedRow!
                let imageURLString = imagesListViewPresenter.getLargeImageURL(at: indexPath)
                guard let imageURL = URL(string: imageURLString) else {
                    assertionFailure("unable to extract fullSizeImageURL")
                    return
                }
                destinationVC.fullSizeImageURL = imageURL
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated(_ oldCount: Int, _ newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
}

//MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { 
            assertionFailure("Something went wrong")
            return
        }
        
        UIBlockingProgressHUD.show()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            imagesListViewPresenter?.didChangeLike(for: cell, at: indexPath) { result in
                switch result {
                case .success:
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    assertionFailure("something went wrong with \(error)")
                }
            }
        }
    }
}

