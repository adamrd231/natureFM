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
        let thirdButton = tabBar.buttons.element(boundBy: 2)

        secondButton.tap()
        XCUIDevice.shared.orientation = UIDeviceOrientation.portrait
        snapshot("1Portrait")
        
        thirdButton.tap()
        XCUIDevice.shared.orientation = UIDeviceOrientation.portrait
        snapshot("2Portrait")
    }
}
