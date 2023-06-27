//
//  ProfileResult.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 13.06.2023.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}
