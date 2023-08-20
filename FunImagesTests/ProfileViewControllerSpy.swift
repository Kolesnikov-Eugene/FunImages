//
//  ProfileViewControllerSpy.swift
//  FunImagesTests
//
//  Created by Eugene Kolesnikov on 20.08.2023.
//

import Foundation
@testable import FunImages

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var profilePresenter: FunImages.ProfileViewPresenter?
    var alertCalled = false
    
    func setProfileInfo(profile: FunImages.Profile) {
    }
    
    func showAlert(_ alertPresenter: FunImages.AlertPresenter, model: FunImages.AlertModel, twoButtons: Bool) {
        alertCalled = true
    }
    
    func switchRootViewControllerToSplashViewController() {
    }
}
