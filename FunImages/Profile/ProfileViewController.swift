//
//  ProfileViewController.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 12.05.2023.
//

import UIKit
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {
    private var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        
        profileImageView.image = UIImage(named: "ProfilePhotoPlaceholder")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.frame.size.width = 70
        profileImageView.frame.size.height = 70
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
        
        return profileImageView
    }()
    private var profileNameLabel: UILabel = {
        let profileNameLabel = UILabel()
        
        profileNameLabel.textColor = .white
        profileNameLabel.text = ""
        profileNameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileNameLabel.frame.size.height = 18
        
        return profileNameLabel
    }()
    private var accountLabel: UILabel = {
        let accountLabel = UILabel()
        
        accountLabel.text = ""
        accountLabel.textColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        accountLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        accountLabel.frame.size.height = 18
        
        return accountLabel
    }()
    private var profileInfoLabel: UILabel = {
        let profileInfoLabel = UILabel()
        
        profileInfoLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        profileInfoLabel.text = ""
        profileInfoLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        profileInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        profileInfoLabel.frame.size.height = 18
        
        return profileInfoLabel
    }()
    private lazy var logOutButton: UIButton = {
        let logOutButton = UIButton.systemButton(with: UIImage(named: "exit")!,
                                                 target: self,
                                                 action: #selector(self.didTapLogOutButton))
        logOutButton.tintColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        return logOutButton
    }()
    private var profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        addSubViews()
        applyConstraints()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self = self else { return }
                self.updateProfileAvatar()
            })
        
        if let profileData = profileService.profileData {
            setProfileInfo(profile: profileData)
        }
        
        updateProfileAvatar()
    }
    
    private func addSubViews() {
        view.addSubview(profileImageView)
        view.addSubview(profileNameLabel)
        view.addSubview(accountLabel)
        view.addSubview(profileInfoLabel)
        view.addSubview(logOutButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            profileNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            profileNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            accountLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            accountLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 8),
            accountLabel.trailingAnchor.constraint(equalTo: profileNameLabel.trailingAnchor),
            profileInfoLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8),
            profileInfoLabel.leadingAnchor.constraint(equalTo: accountLabel.leadingAnchor),
            profileInfoLabel.trailingAnchor.constraint(equalTo: profileNameLabel.trailingAnchor),
            logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            logOutButton.leadingAnchor.constraint(greaterThanOrEqualTo: profileImageView.trailingAnchor),
            logOutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }
    
    private func setProfileInfo(profile: Profile) {
        profileNameLabel.text = profile.name
        profileInfoLabel.text = profile.bio
        accountLabel.text = profile.logName
    }
    
    private func updateProfileAvatar() {
        let url = URL(string: self.profileImageService.avatarURL!)!
        
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        
        profileImageView.kf.setImage(
            with: url,
            options: [.processor(processor)])
    }
    
    @objc
    private func didTapLogOutButton(_ sender: UIButton) {
        OAuth2TokenStorage.shared.deleteToken()
        
        OAuth2TokenStorage.clean()
        
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
            else {
                if let view = view as? UIImageView {
                    view.image = UIImage(named: "ProfilePhotoPlaceholder")
                }
            }
        }
        
        present(SplashViewController(), animated: true)
    }
}
