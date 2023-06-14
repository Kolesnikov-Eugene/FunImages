//
//  UserResult.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 14.06.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
}

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}
