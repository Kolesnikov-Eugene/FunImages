//
//  ImagesListCell.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 06.05.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var imageForCell: UIImageView!
    
    static let reuseIdentifier = "ImagesListCell"
    private var cellHasGradient = false
    weak var delegate: ImagesListCellDelegate?
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageForCell.kf.cancelDownloadTask()
    }
    
    func configCell(with cellModel: ImageListCellModel) {
        let imagePlaceholder = UIImage(named: "placeholder_feed")
        
        imageForCell.kf.indicatorType = .activity
        imageForCell.kf.setImage(with: cellModel.imageForCell, placeholder: imagePlaceholder)
        
        dateLabel.text = cellModel.dateLabelText
        likeButton.setImage(cellModel.likeButtonImage, for: .normal)
    }
    
    func addGradientIfNeeded() {
        if !cellHasGradient {
            addGradient()
            cellHasGradient = true
        }
    }
    
    func changeLike(isLiked: Bool) {
        let cellLikeButtonImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(cellLikeButtonImage, for: .normal)
    }
    
    private func addGradient() {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: 30)
        view.backgroundColor = .clear

        let gradientlayer = CAGradientLayer()
        let colorTop = UIColor(named: "gradientTop")?.cgColor ?? UIColor.clear.cgColor
        let colorBottom = UIColor(named: "gradientBottom")?.cgColor ?? UIColor.clear.cgColor
        gradientlayer.colors = [colorTop, colorBottom]
        gradientlayer.locations = [0, 1]
        gradientlayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientlayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientlayer.frame = view.bounds
        gradientlayer.position = view.center
        view.layer.addSublayer(gradientlayer)

        let parent = self.imageForCell!
        parent.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: 0).isActive = true
    }

    @IBAction private func likeButtonClicked(_ sender: UIButton) {
        delegate?.imagesListCellDidTapLike(self)
    }
}
