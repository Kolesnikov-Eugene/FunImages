//
//  WebViewViewControllerDelegate.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 28.05.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
