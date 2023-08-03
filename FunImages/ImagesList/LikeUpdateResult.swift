//
//  LikeUpdateResult.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 03.08.2023.
//

import Foundation

struct LikeUpdateResult: Codable {
    let photo: UpdatedPhoto
}

struct UpdatedPhoto: Codable {
    let id: String
}
