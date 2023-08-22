//
//  WebViewViewControllerSpy.swift
//  FunImagesTests
//
//  Created by Eugene Kolesnikov on 16.08.2023.
//

import Foundation
import FunImages

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: FunImages.WebViewPresenterProtocol?
    var loadRequestCalled = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
