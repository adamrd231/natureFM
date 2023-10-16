//
//  natureFMUITests.swift
//  natureFMUITests
//
//  Created by Adam Reed on 10/16/23.
//

import XCTest

final class natureFMUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    func testExample() {
        snapshot("0Launch")
        let tabBar = XCUIApplication().tabBars
        let secondButton = tabBar.buttons.element(boundBy: 1)

        XCUIDevice.shared.orientation = UIDeviceOrientation.landscapeLeft
        snapshot("1LandscapeLeft")

        secondButton.tap()
        XCUIDevice.shared.orientation = UIDeviceOrientation.landscapeRight
        snapshot("2LandscapeRight")

        secondButton.tap()
        XCUIDevice.shared.orientation = UIDeviceOrientation.portrait
        snapshot("3Portrait")
    }
}
