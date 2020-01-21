//
//  EosioServiceTests.swift
//  WombatEOSTests
//
//  Created by Reshma Unnikrishnan on 20.01.20.
//  Copyright © 2020 ruvlmoon. All rights reserved.
//

import XCTest
import Combine

@testable import WombatEOS

class MockNetworkAPI: NetworkAPIType {
  var expectation: XCTestExpectation?
  
  func postRequest<T>(router: EosioRouter, httpBody: Data) -> AnyPublisher<T, NetworkError> where T : Decodable {

    if router == EosioRouter.getAccount {
      do {
        if let json: [String: String] = try JSONSerialization.jsonObject(with: httpBody, options:.allowFragments) as? [String : String] {
          if json["account_name"] == "test" {
            expectation?.fulfill()
          }
        }
      } catch {}
    }
    
    return PassthroughSubject<T, NetworkError>().eraseToAnyPublisher()
  }
}

class EosioServiceTests: XCTestCase {
  var service: EosioService!
  var networkAPI: MockNetworkAPI!
  
  override func setUp() {
    networkAPI = MockNetworkAPI()
    service = EosioService(networkAPI: networkAPI)
  }
  
  override func tearDown() {
    service = nil
    networkAPI = nil
  }
  
  func testGetAccountIsCalledWithProperParams() {
    let expectation = self.expectation(description: "get account")
    networkAPI.expectation = expectation
    
    service
      .getAccount(accountName: "test")
      .sink(receiveCompletion: { (_) in
      
        }) { (account) in
          
        }
      .cancel()
    
    waitForExpectations(timeout: 5, handler: nil)
  }
}
