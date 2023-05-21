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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addProfileImageView()
//        addProfileNameLabel()
//        addAccountLabel()
//        addProfileInfoLabel()
//        addLogOutButton()
    }
    private func addProfileImageView() {
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(named: "profile_photo")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                              constant: 32).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                  constant: 16).isActive = true
        
        let profileNameLabel = UILabel()
        profileNameLabel.frame.size.height = 18
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileNameLabel)
        profileNameLabel.textColor = .white
        profileNameLabel.text = "Екатерина Новикова"
        profileNameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        profileNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        profileNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,
                                              constant: 8).isActive = true
        profileNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: 16).isActive = true
        
        let accountLabel = UILabel()
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(accountLabel)
        
        accountLabel.frame.size.height = 18
        accountLabel.textColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        accountLabel.text = "@ekaterina_nov"
        accountLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        accountLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        accountLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 8).isActive = true
        accountLabel.trailingAnchor.constraint(equalTo: profileNameLabel.trailingAnchor).isActive = true
        
        let profileInfoLabel = UILabel()
        profileInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileInfoLabel)
        
        profileInfoLabel.frame.size.height = 18
        profileInfoLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        profileInfoLabel.text = "Hello, World!"
        profileInfoLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        profileInfoLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8).isActive = true
        profileInfoLabel.leadingAnchor.constraint(equalTo: accountLabel.leadingAnchor).isActive = true
        profileInfoLabel.trailingAnchor.constraint(equalTo: profileNameLabel.trailingAnchor).isActive = true
        
        let logOutButton = UIButton.systemButton(with: UIImage(named: "exit")!,
                                                 target: self,
                                                 action: #selector(self.didTapLogOutButton))
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.tintColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        view.addSubview(logOutButton)
        
//        logOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55).isActive = true
        logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                               constant: -20).isActive = true
        logOutButton.leadingAnchor.constraint(greaterThanOrEqualTo: profileImageView.trailingAnchor).isActive = true
        logOutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
    }
    private func addProfileNameLabel() {
        
    }
    private func addAccountLabel() {
        
    }
    private func addProfileInfoLabel() {
        
    }
    private func addLogOutButton() {
        
    }
    @objc
    private func didTapLogOutButton(_ sender: UIButton) {
    }
    
}
