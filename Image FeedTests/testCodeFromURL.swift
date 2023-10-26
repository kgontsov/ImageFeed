//
//  testCodeFromURL.swift
//  testCodeFromURL
//
//  Created by Kirill Gontsov on 20.10.2023.
//

@testable import ImageFeed
import XCTest

final class testCodeFromURL: XCTestCase {
    func testCodeFromURL() {
        //given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        
        //when
        let code = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(code, "test code")
    }
}
