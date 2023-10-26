//
//  testPresenterCallsLoadRequest.swift
//  testPresenterCallsLoadRequest
//
//  Created by Kirill Gontsov on 20.10.2023.
//

@testable import ImageFeed
import XCTest

final class testPresenterCallsLoadRequest: XCTestCase {
    func testPresenterCallsLoadRequest() {
        //given
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
}
