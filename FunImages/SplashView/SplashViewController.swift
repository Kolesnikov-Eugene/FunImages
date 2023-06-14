//
//  SplashViewController.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 06.06.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private var profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    private var oauth2Service = OAuth2Service.shared
    private var oauth2Storage = OAuth2TokenStorage.shared
    private var userName: String? {
        profileService.profileData?.userName
    }
    
    var token: String? {
        oauth2Storage.token ?? nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if token != nil {
            fetchProfile(token!)
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarViewController = UIStoryboard(
            name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarViewController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { return assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthanticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchAuthToken(code)
        }
    }
    
    private func fetchAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                print(result) //delete
                fetchProfile(token!)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error)
                break
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                UIBlockingProgressHUD.dismiss()
                
                profileImageService.fetchProfileImageURL(
                    username: self.profileService.profileData!.userName) { result in
                        switch result {
                        case .success:
                            print(result)
                            print("GOOOOOOOOOOD111")
                            
                        case .failure(let error):
                            print(error)
                            print("BAAAAAAAD")
                        }
                    }
                self.switchToTabBarController()
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}
