//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Kirill Gontsov on 26.04.2023.
//


import UIKit

final class ProfileViewController: UIViewController {
    
    // Хранимые свойства для компонентов UI
    private let profileImage = UIImageView(image: UIImage(named: "avatar"))
    private let userName = UILabel()
    private let nickName = UILabel()
    private let profileDescription = UILabel()
    private let logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        // Настройка компонентов UI
        userName.textColor = .ypWhite
        userName.text = "Екатерина Новикова"
        userName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        nickName.textColor = .ypGray
        nickName.text = "@ekaterina_nov"
        nickName.font = UIFont.systemFont(ofSize: 13)
        
        profileDescription.textColor = .ypWhite
        profileDescription.text = "Hello, world!"
        profileDescription.font = UIFont.systemFont(ofSize: 13)
        
        logoutButton.setImage(UIImage(named: "logout_button"), for: .normal)
    }
    
    private func setupConstraints() {
        // Установка констрейнтов
        view.addSubview(profileImage)
        view.addSubview(userName)
        view.addSubview(nickName)
        view.addSubview(profileDescription)
        view.addSubview(logoutButton)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        nickName.translatesAutoresizingMaskIntoConstraints = false
        profileDescription.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            userName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            userName.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            nickName.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8),
            nickName.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            profileDescription.topAnchor.constraint(equalTo: nickName.bottomAnchor, constant: 8),
            profileDescription.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
        ])
    }
}

