//
//  SplashViewController.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 06.06.2023.


import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private var splashScreenImageView: UIImageView!
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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSplashScreen()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if token != nil {
            fetchProfile(token!)
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
            case .success:
                print(result) //delete
                fetchProfile(token!)
            case .failure(let error):
                print(error)
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
                    username: self.profileService.profileData!.userName) { result in
                        switch result {
                        case .success:
                            print(result)
                            print("GOOOOOOOOOOD")

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
    private func configureSplashScreen() {
        view.backgroundColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)

        splashScreenImageView = UIImageView()
        splashScreenImageView.image = UIImage(named: "launchScreenLogo")
        view.addSubview(splashScreenImageView)

        setConstraintsToSplashImageView()
    }

    private func setConstraintsToSplashImageView() {
        splashScreenImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            splashScreenImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            splashScreenImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}

// если убирать сплеш сразу после получения токена, то в случае ошибки при загрузке профиля -
// алерт исчезнет вместе с auth скрином. поэтому убирать экран нужно не сразу

