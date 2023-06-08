//
//  AuthViewControllerDelegate.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 06.06.2023.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthanticateWithCode code: String)
}
