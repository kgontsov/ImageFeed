//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Kirill Gontsov on 01.08.2023.
//

import Foundation


class OAuth2TokenStorage {
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: OAuthTokenResponseBody.CodingKeys.accessToken.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: OAuthTokenResponseBody.CodingKeys.accessToken.rawValue)
        }
    }
}
