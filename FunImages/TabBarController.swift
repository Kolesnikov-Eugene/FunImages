//
//  TabBarController.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 21.06.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        
        guard let imagesListViewController = imagesListViewController as? ImagesListViewController else {
            assertionFailure("unable to instantiate ImagesListViewController")
            return
        }
        let imagesListViewPresenter = ImagesListViewPresenter()
        imagesListViewController.configure(imagesListViewPresenter)
        
        let profileViewController = ProfileViewController() 
        let profileViewPresenter = ProfileViewPresenter()
        
        profileViewController.profilePresenter = profileViewPresenter
        profileViewPresenter.profileView = profileViewController
        
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
