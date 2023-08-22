//
//  Constants.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 25.05.2023.
//

import Foundation

let AccessKey = "306_omByg5nvoy7lJu7AG4DvRNjPW40qdjVakWS_0jY"
let SecretKey = "7w5nRW0pBykZ6xZzG8UKeX7fxobwul8LX8eSs9N5Uek"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL: URL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURL = "https://unsplash.com/oauth/authorize"
let UrlForToken = URL(string: "https://unsplash.com")!

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 authURLString: UnsplashAuthorizeURL,
                                 defaultBaseURL: DefaultBaseURL)
    }
}


//struct Constants {
//    static let accessKey = "306_omByg5nvoy7lJu7AG4DvRNjPW40qdjVakWS_0jY"
//    static let secretKey = "7w5nRW0pBykZ6xZzG8UKeX7fxobwul8LX8eSs9N5Uek"
//    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
//    static let accessScope = "public+read_user+write_likes"
//    static let unsplashAuthorizeURL = "https://unsplash.com/oauth/authorize"
//    static let urlForToken = URL(string: "https://unsplash.com")!
//    static let defaultBaseURL: URL = URL(string: "https://api.unsplash.com")!
//}

