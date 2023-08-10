//
//  Photo.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 27.06.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageUrl: String
    let largeImageUrl: String
    let isLiked: Bool
}
