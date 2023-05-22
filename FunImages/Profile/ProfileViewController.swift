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
        setContentAndConstraintsToView()
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
        profileNameLabel.text = "Екатерина Новикова"
        profileNameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        addProfileNameLabelConstraints()
        
        accountLabel = UILabel()
        view.addSubview(accountLabel)
        accountLabel.text = "@ekaterina_nov"
        accountLabel.textColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        accountLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        addAccountLabelConstraints()
        
        profileInfoLabel = UILabel()
        view.addSubview(profileInfoLabel)
        profileInfoLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        profileInfoLabel.text = "Hello, World!"
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
    
    @objc
    private func didTapLogOutButton(_ sender: UIButton) {
    }
}
