//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Kirill Gontsov on 01.08.2023.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = OAuth2TokenStorage().token {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: "AuthViewSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AuthViewSegue" {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Can not find AuthViewController") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
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
     //   ProgressHUD.show()
        OAuth2Service().fetchAuthToken(code) { result in
            switch result {
            case .success(let accessToken):
                OAuth2TokenStorage().token = accessToken
             //   ProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure(let error):
                print("Failed: \(error)")
             //   ProgressHUD.dismiss()
                break
            }
        }
    }
}
