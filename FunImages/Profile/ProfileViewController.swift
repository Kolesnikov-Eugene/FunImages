//
//  ProfileViewController.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 12.05.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private var profileImageView: UIImageView!
    private var profileNameLabel: UILabel!
    private var accountLabel: UILabel!
    private var profileInfoLabel: UILabel!
    private var logOutButton: UIButton!
    private var profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self = self else { return }
                self.updateProfileAvatar()
            })
        
        setContentAndConstraintsToView()
        setProfileInfo(profile: profileService.profileData!)
        updateProfileAvatar()
//        ProfileImageService.shared.fetchProfileImageURL(
//            username: profileService.profileData!.userName) { result in
//                switch result {
//                case .success:
//                    print("GOOOOOOOOOOD")
//                case .failure:
//                    print("error")
//                }
//            }
//        ProfileService.shared.fetchProfile(OAuth2TokenStorage.shared.token!) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success:
//                print(ProfileService.shared.profileData)
//                setProfileInfo()
//            case .failure(let error):
//                print(error)
//                break
//            }
//        }
        
    }
    
    private func setContentAndConstraintsToView() {
        view.backgroundColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        
        profileImageView = UIImageView()
        profileImageView.image = UIImage(named: "profile_photo")
        view.addSubview(profileImageView)
        addProfileImageViewConstraints()
        
        profileNameLabel = UILabel()
        view.addSubview(profileNameLabel)
        profileNameLabel.textColor = .white
        profileNameLabel.text = ""
        profileNameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        addProfileNameLabelConstraints()
        
        accountLabel = UILabel()
        view.addSubview(accountLabel)
        accountLabel.text = ""
        accountLabel.textColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        accountLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        addAccountLabelConstraints()
        
        profileInfoLabel = UILabel()
        view.addSubview(profileInfoLabel)
        profileInfoLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        profileInfoLabel.text = ""
        profileInfoLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        addProfileInfoLabelConstraints()
        
        logOutButton = UIButton.systemButton(with: UIImage(named: "exit")!,
                                                 target: self,
                                                 action: #selector(self.didTapLogOutButton))
        logOutButton.tintColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        view.addSubview(logOutButton)
        addLogOutButtonConstraints()
    }
    
    private func addProfileImageViewConstraints() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func addProfileNameLabelConstraints() {
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileNameLabel.frame.size.height = 18
        NSLayoutConstraint.activate([
            profileNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            profileNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            profileNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16)
        ])
    }
    
    private func addAccountLabelConstraints() {
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        accountLabel.frame.size.height = 18
        NSLayoutConstraint.activate([
            accountLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            accountLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 8),
            accountLabel.trailingAnchor.constraint(equalTo: profileNameLabel.trailingAnchor)
        ])
    }
    
    private func addProfileInfoLabelConstraints() {
        profileInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        profileInfoLabel.frame.size.height = 18
        NSLayoutConstraint.activate([
            profileInfoLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8),
            profileInfoLabel.leadingAnchor.constraint(equalTo: accountLabel.leadingAnchor),
            profileInfoLabel.trailingAnchor.constraint(equalTo: profileNameLabel.trailingAnchor)
        ])
    }
    
    private func addLogOutButtonConstraints() {
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
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
        DispatchQueue.global().async {
            let url = URL(string: self.profileImageService.avatarURL!)!
            
            if let data = try? Data(contentsOf: url) {
                let image1 = UIImage(data: data)
                
                DispatchQueue.main.async { [self] in
                    profileImageView.image = image1
                }
            }
            
            
        }
    }
    
    @objc
    private func didTapLogOutButton(_ sender: UIButton) {
    }
}
