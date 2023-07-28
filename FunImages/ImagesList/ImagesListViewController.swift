//
//  ViewController.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 01.05.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var imagesListService = ImagesListService.shared
    private let showSingleImageViewIdentifier = "ShowSingleImage"
    private var imagesListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
//    private let imagesName: [String] = Array(0..<20).map{ "\($0)" } //dont need anymore
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
      
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imagesListService.fetchPhotosNextPage()
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main,
                using: { [ weak self ] _ in
                    guard let self else { return assertionFailure("failed to capture self") }
                    self.updateTableViewAnimated()
                })
    }
}

// MARK: - TableView Data Source
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos = imagesListService.photos
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        imageListCell.addGradientIfNeeded()
        
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
//        let imageName = imagesName[indexPath.row]
        let currentImage = photos[indexPath.row]
        let imageURL = URL(string: currentImage.thumbImageUrl)!
//        guard let image = UIImage(named: imageName) else { return }
        guard let currentDate = currentImage.createdAt else {
            return assertionFailure("unable to extract date")
        }

        let dateText = dateFormatter.string(from: currentDate)
        
        let likeIsOn = indexPath.row % 2 != 0
        let cellLikeButttonImage = likeIsOn ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        
        let cellModel = ImageListCellModel(
            imageForCell: imageURL,
            dateLabelText: dateText,
            likeButtonImage: cellLikeButttonImage!)
        
        cell.configCell(with: cellModel)
    }
}
// MARK: - TableView Delegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath
    ) {
        let currentIndex = indexPath.row + 1
        
        if currentIndex == imagesListService.photos.count { //TODO
            imagesListService.fetchPhotosNextPage() //TODO
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageViewIdentifier, sender: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //height and width in PhotoResult
//        guard let image = UIImage(named: imagesName[indexPath.row]) else {
//            return 0
//        }
        let imageSize = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //download fullSize image? via kingFisher
        if segue.identifier == showSingleImageViewIdentifier {
            if let destinationVC = segue.destination as? SingleImageViewController {
                let indexPath = tableView.indexPathForSelectedRow!
//                let image = UIImage(named: imagesName[indexPath.row])
                let imageURLString = photos[indexPath.row].largeImageUrl
                let imageURL = URL(string: imageURLString)!
                destinationVC.fullSizeImageURL = imageURL
                print(imageURL)
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
        
        //        let oldIndex = photos.count - 1
        //        let currentIndex = imagesListService.photos.count - 1
        //        photos = imagesListService.photos
        //        if oldIndex != currentIndex {
        //            if oldCount != newCount {
        //                tableView.performBatchUpdates {
        //                    let indexPaths = (oldCount..<newCount).map { i in
        //                        IndexPath(row: i, section: 0)
        //                    }
        //                    self.tableView.performBatchUpdates {
        //                        tableView.insertRows(at: indexPaths, with: .automatic)
        //                    } completion: { _ in }
        //                }
        //            }
        //        }
    }
}

