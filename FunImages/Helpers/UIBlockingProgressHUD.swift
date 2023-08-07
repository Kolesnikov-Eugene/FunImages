//
//  UIBlockingProgressHUD.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 13.06.2023.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    static var shared = UIBlockingProgressHUD()
    
    private init() { }
    
    private static var window: UIWindow? {
        UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
