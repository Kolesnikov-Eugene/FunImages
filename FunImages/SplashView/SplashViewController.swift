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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if OAuth2TokenStorage.shared.token != nil {
            switchToTabBarController()
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
        OAuth2Service.shared.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                print(result) //delete
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}
