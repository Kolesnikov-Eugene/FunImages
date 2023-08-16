//
//  WebViewPresenterSpy.swift
//  FunImagesTests
//
//  Created by Eugene Kolesnikov on 16.08.2023.
//

import Foundation
import FunImages

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled = false
    var view: FunImages.WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
    
}
