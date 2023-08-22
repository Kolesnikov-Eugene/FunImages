//
//  ProfileViewPresenterSpy.swift
//  FunImagesTests
//
//  Created by Eugene Kolesnikov on 20.08.2023.
//

import Foundation
@testable import FunImages

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var profileView: FunImages.ProfileViewControllerProtocol?

    func didUpdateProfileAvatar() {
    }

    func didUpdateProfileInfo() {
        
    }

    func didExitProfile() {
    }


}
