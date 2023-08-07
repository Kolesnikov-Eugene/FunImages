//
//  PhotoResult.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 27.06.2023.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
}

struct UrlsResult: Codable {
    let thumb: String
    let full: String
}

