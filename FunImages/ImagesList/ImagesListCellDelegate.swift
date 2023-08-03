//
//  ImagesListCellDelegate.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 01.08.2023.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}
