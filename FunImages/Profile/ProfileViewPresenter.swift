//
//  ProfileViewPresenter.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 19.08.2023.
//

import UIKit
import Kingfisher

protocol ProfileViewPresenterProtocol {
    var profileView: ProfileViewControllerProtocol? { get set }
    func didUpdateProfileAvatar()
    func didUpdateProfileInfo()
    func didExitProfile()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var profileView: ProfileViewControllerProtocol?
    private var profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    
    func didExitProfile() {
        showExitAlert()
    }
    
    func didUpdateProfileAvatar() {
        guard let url = URL(string: self.profileImageService.avatarURL!) else { return }
        
        let profileView = profileView as! ProfileViewController
        
        let processor = RoundCornerImageProcessor(cornerRadius: profileView.profileImageView.frame.height / 2)
        
        profileView.profileImageView.kf.setImage(
            with: url,
            options: [.processor(processor)])
    }
    
    func didUpdateProfileInfo() {
        if let profileData = profileService.profileData {
            profileView?.setProfileInfo(profile: profileData)
        }
    }
    
    private func showExitAlert() {
        let alertPresenter = AlertPresenter()
        let alertModel = AlertModel(
            title: "Пока, Пока!",
            message: "Уверены, что хотите выйти?",
            okButtonText: "Да",
            cancelButtonText: "Нет") {
                self.clearUserAuthInfo()
                
                self.profileView?.switchRootViewControllerToSplashViewController()
            }
        
        profileView?.showAlert(alertPresenter, model: alertModel, twoButtons: true)
    }
    
    private func clearUserAuthInfo() {
        OAuth2TokenStorage.shared.deleteToken()
        
        CookiesCleaner.cleanCookies()
    }
}
