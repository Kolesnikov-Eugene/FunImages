//
//  AlertModel.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 03.08.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let okButtonText: String
    let cancelButtonText: String?
    let completion: () -> ()
}
