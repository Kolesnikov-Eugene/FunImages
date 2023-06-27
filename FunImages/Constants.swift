//
//  Constants.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 25.05.2023.
//

import Foundation

struct Constants {
    static let accessKey = "306_omByg5nvoy7lJu7AG4DvRNjPW40qdjVakWS_0jY"
    static let secretKey = "7w5nRW0pBykZ6xZzG8UKeX7fxobwul8LX8eSs9N5Uek"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let unsplashAuthorizeURL = "https://unsplash.com/oauth/authorize"
    static let urlForToken = URL(string: "https://unsplash.com")!
    static let defaultBaseURL: URL = URL(string: "https://api.unsplash.com")!
}

