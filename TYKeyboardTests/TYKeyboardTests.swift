//
//  TYKeyboardTests.swift
//  TYKeyboardTests
//
//  Created by Tory on 2020/11/21.
//

import XCTest
@testable import TYKeyboard

class TYKeyboardTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let form = Form()
        
        form >>>
            Row(height: 40)
            +++ Column(ratio: 1).addItems({ (form) in
                // 添加行
                form >>> Row(height: 40)
                    >>> Row(height: 40)
                        +++ TitleItem(title: "按钮0", ratio: 1)
                        +++ Column(ratio: 1)
                
            })
            +++ Column(ratio: 1).addItems({ (form) in
                // 添加列
            })
            
            >>> Row(height: 60)
                +++ TitleItem(title: "按钮1", ratio: 1)
                +++ Column(ratio: 1)
                
            
     
        print("-----------")
        print(form)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
