//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Jeevanantham Kalyanasundram on 2/23/17.
//  Copyright © 2017 Jeevanantham Kalyanasundram. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWeatherInfoFetch() {
        
        let RequestUrl:String = "http://api.openweathermap.org/data/2.5/weather?APPID=a241aca7068f1107227442653a64682c&q=Chicago"
        
        // This is the shared session will do.
        let session = URLSession.shared
        
        //Converting string to URL
        let url = URL(string: RequestUrl)!
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                // An error occurred while trying to get data from the server.
            }
            else {
                print("Success")
                // We got weather info data from the server!
                XCTAssertNotNil(data)
            }
            
        })
        
        task.resume()
        
    }
    
    func testIconImageFetch() {
        
        let RequestUrl:String = "http://openweathermap.org/img/w/04n.png"
        
        // This is the shared session will do.
        let session = URLSession.shared
        
        //Converting string to URL
        let url = URL(string: RequestUrl)!
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                // An error occurred while trying to get data from the server.
            }
            else {
                print("Success")
                // We got image data from the server!
                XCTAssertNotNil(data)
            }
            
        })
        
        task.resume()
        
    }
    
}
