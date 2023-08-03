//
//  SingleImageViewController.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 13.05.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView! //return private. Create public method to download image?
    
    var fullSizeImageURL: URL? {
        didSet {
            guard isViewLoaded else { return }
            loadImage()
        }
    }
//    var fullSizeImageURL: URL?
//    private var image: UIImage!
    private var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        scrollView.maximumZoomScale = 1
        scrollView.minimumZoomScale = 0.2
//        rescaleAndCenterImageInScrollView(image: image)
    }
    
    @IBAction func didPressBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        let activityController = UIActivityViewController(
            activityItems: [image!],
            applicationActivities: nil)
        
        present(activityController, animated: true)
    }
    
    private func loadImage() {
        guard let fullSizeImageURL else { return }
        imageView.kf.setImage(with: fullSizeImageURL) { [ weak self] result in // try this method ?
            guard let self = self else { return }
            switch result {
            case .success(let value):
                UIBlockingProgressHUD.dismiss()
                self.image = value.image
                self.rescaleAndCenterImageInScrollView(image: self.image)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                let alertPresenter = AlertPresenter()
                let alertModel = AlertModel(
                    title: "Что-то пошло не так",
                    message: "Попробовать еще раз?",
                    buttonText: "OK",
                    completion: {
                        self.loadImage()
                        UIBlockingProgressHUD.show() // try here
                    }
                )
//                self.showAlert()
                alertPresenter.show(in: self, model: alertModel)
            }
        }
    }
    
//    private func showAlert() {
//        let alert = UIAlertController(title: "Что-то пошло не так(",
//                                      message: "Попробовать еще раз?",
//                                      preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
//            guard let self else { return }
//            self.loadImage()
//        }
//
////        let cancelAction = UIAlertAction(title: "Не надо", style: .default) { [weak self] _ in
////            guard let self = self else { return }
////
////        }
//
//        alert.addAction(okAction)
////        alert.addAction(cancelAction)
//
//        present(alert, animated: true)
//    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()

        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()

        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
}


