//
//  testProgressHiddenWhenOne.swift
//  testProgressHiddenWhenOne
//
//  Created by Kirill Gontsov on 20.10.2023.
//

@testable import ImageFeed
import XCTest

final class TestProgressHiddenWhenOne: XCTestCase {
    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
}
