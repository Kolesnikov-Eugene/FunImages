//
//  JSONDecoder+Extensions.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 08.06.2023.
//

import Foundation

class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
