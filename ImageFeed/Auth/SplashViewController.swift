//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Kirill Gontsov on 01.08.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private var profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    private var oauthService = OAuth2Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let splashScreenLogo = splashScreenLogo()
        NSLayoutConstraint.activate([
            splashScreenLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashScreenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        if let token = OAuth2TokenStorage().token {
            self.profileService.fetchProfile(token)
            self.profileImageService.fetchProfileImageURL(username: profileService.getProfile()?.username ?? "") { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        assertionFailure(error.localizedDescription)
                        self.showAlert()
                    }
                case .success(_):
                    DispatchQueue.main.async {
                        self.switchToTabBarController()
                    }
                }
            }
        } else {
            guard let authViewController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { fatalError("Invalid Configuration") }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
    
    private func switchToTabBarController() {
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func acceptToken(code: String) {
        UIBlockingProgressHUD.show()
        oauthService.fetchAuthToken(code) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let accessToken):
                    OAuth2TokenStorage().token = accessToken
                    self.profileService.fetchProfile(accessToken)
                    self.profileImageService.fetchProfileImageURL(username: self.profileService.getProfile()?.username ?? "") { [weak self] result in
                        guard let self = self else { return }
                        UIBlockingProgressHUD.dismiss()
                        switch result {
                        case .failure(_):
                            self.dismiss(animated: false)
                            self.showAlert()
                        case .success(_):
                            self.switchToTabBarController()
                        }
                    }
                case .failure(let error):
                    print("Failed: \(error)")
                    UIBlockingProgressHUD.dismiss()
                    self.dismiss(animated: false)
                    self.showAlert()
                    break
                }
            }
        }
    }
}

extension SplashViewController {
    func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: { _ in })
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func splashScreenLogo() -> UIImageView {
        let splashScreenLogo = UIImageView(image: UIImage(named: "auth_screen_logo"))
        view.addSubview(splashScreenLogo)
        splashScreenLogo.translatesAutoresizingMaskIntoConstraints = false
        
        return splashScreenLogo
    }
}

