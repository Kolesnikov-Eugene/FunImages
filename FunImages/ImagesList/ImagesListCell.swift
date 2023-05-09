//
//  ImagesListCell.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 06.05.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageForCell: UIImageView?
    static let reuseIdentifier = "ImagesListCell"
}
