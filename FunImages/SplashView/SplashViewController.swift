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
        fetchAuthToken(code)
//        dismiss(animated: true) { [weak self] in
//            guard let self = self else { return }
//            self.fetchAuthToken(code)
//        }
    }
    
    private func fetchAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                print(result) //delete
                fetchProfile(token!)
//                dismiss(animated: true)
            case .failure(let error):
                print(error)
                showAlert()
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
//            dismiss(animated: true) ??
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
//                            self.showAlert()
                        }
                    }
                self.switchToTabBarController()
                dismiss(animated: true) //думаю, нужно убирать здесь
            case .failure:
                showAlert()
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [self] _ in
            if token != nil {
                fetchProfile(token!)
            } else {
                performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
                UIBlockingProgressHUD.dismiss()
            }
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

// если убирать сплеш сразу после получения токена, то в случае ошибки при загрузке профиля -
// алерт исчезнет вместе с auth скрином. поэтому убирать экран нужно не сразу
