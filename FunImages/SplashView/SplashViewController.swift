//
//  SplashViewController.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 06.06.2023.


import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private var splashScreenImageView: UIImageView = {
        let splashScreenImageView = UIImageView()

        splashScreenImageView.image = UIImage(named: "launchScreenLogo")
        splashScreenImageView.translatesAutoresizingMaskIntoConstraints = false

        return splashScreenImageView
    }()
    private var profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    private var oauth2Service = OAuth2Service.shared
    private var oauth2Storage = OAuth2TokenStorage.shared
    private var userName: String? {
        profileService.profileData?.userName
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        addSubViews()
        applyConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if let token = oauth2Storage.token {
            fetchProfile(token)
        } else {
            showAuthViewController()
        }
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }

        let tabBarViewController = UIStoryboard(
            name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarViewController
    }

    private func showAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            return
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
}
//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthanticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        fetchAuthToken(code)
    }

    private func fetchAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                fetchProfile(token)
            case .failure:
                showAlert()
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
                    username: self.profileService.profileData!.userName) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success:
                            break
                        case .failure:
                            self.showAlert()
                        }
                    }
                self.switchToTabBarController()
                dismiss(animated: true)
            case .failure:
                showAlert()
            }
        }
    }

    private func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if let token = oauth2Storage.token {
                fetchProfile(token)
            } else {
                showAuthViewController()
                UIBlockingProgressHUD.dismiss()
            }
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

// MARK: - Configuration SplashScreenViewController
extension SplashViewController {
    private func addSubViews() {
        view.addSubview(splashScreenImageView)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            splashScreenImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            splashScreenImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}

