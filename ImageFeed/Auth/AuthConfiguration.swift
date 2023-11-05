//
//  Constants.swift
//  ImageFeed
//
//  Created by Kirill Gontsov on 04.07.2023.
//

import Foundation

let fileAccessKey = "Cmk-qBrcPR6pjLRzexDaJYjuh6_SxvFdUhOAX9o5U4s"
let fileSecretKey = "gOg4oImbpQd9BJ4ff_TOrVSCCfUm7haxY9J-vTLMQ3s"
let fileRedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let fileAccessScope = "public+read_user+write_likes"
let fileDefaultBaseURL = URL(string: "https://api.unsplash.com")!
let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: fileAccessKey,
                                     secretKey: fileSecretKey,
                                     redirectURI: fileRedirectURI,
                                     accessScope: fileAccessScope,
                                     defaultBaseURL: fileDefaultBaseURL,
                                     authURLString: unsplashAuthorizeURLString)
        }
}
