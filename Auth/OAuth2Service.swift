//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Kirill Gontsov on 01.08.2023.
//

import Foundation

class OAuth2Service {
    
    func fetchAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let request = makeRequest(code)
        callUnsplash(request: request) { (result: Result<Data, Error>)  in
            let parsed = result.flatMap { data -> Result<String, Error> in
                Result{ try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data).accessToken }
            }
            completion(parsed)
        }
    }
    
    private func makeRequest(_ code: String) -> URLRequest {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "client_secret", value: secretKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
    
    private func callUnsplash(
        request: URLRequest,
        responseHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                responseHandler(result)
            }
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            }
            if let responseCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= responseCode {
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(responseCode)))
                }
            }
            if let data = data {
                fulfillCompletion(.success(data))
            }
        }
        task.resume()
    }
}

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
}
