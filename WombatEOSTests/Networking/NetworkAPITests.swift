//
//  NetworkAPITests.swift
//  WombatEOSTests
//
//  Created by Reshma Unnikrishnan on 20.01.20.
//  Copyright © 2020 ruvlmoon. All rights reserved.
//

import XCTest
import Combine

@testable import WombatEOS

class NetworkAPITests: XCTestCase {
  var networkResponseMocks: NetworkResponseMocks!
  var urlSession: URLSession!
  var networkAPI: NetworkAPI!
  var mockData: Data!
  
  override func setUp() {
    networkResponseMocks = NetworkResponseMocks()
    
    let bundle = Bundle(for: type(of: self))
    
    if let path = bundle.path(forResource: "mockaccount", ofType: "json") {
      do {
        mockData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
      } catch {}
    }
    
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [URLProtocolMock.self]
    
    urlSession = URLSession(configuration: config)
    networkAPI = NetworkAPI(urlSession: urlSession)
  }
  
  override func tearDown() {
    networkAPI = nil
    urlSession = nil
    networkResponseMocks = nil
  }
  
  func testPostRequestWithProperResponseReturnsObject() {
    let url = URL(string: "https://api.eosn.io/v1/chain/get_account?")
    URLProtocolMock.testURLs = [url: mockData]
    
    URLProtocolMock.response = networkResponseMocks.validResponse
    
    let valueReceivedExpectation = self.expectation(description: "value received expectation")
    let completionFinishedExpectation = self.expectation(description: "completion finished expectation")
    let completionFailureExpectation = self.expectation(description: "completion failure expectation")
    completionFailureExpectation.isInverted = true
    
    let request: AnyPublisher<Account, NetworkError> = networkAPI.postRequest(router: EosioRouter.getAccount, httpBody: Data("".utf8))
    
    request
      .sink(receiveCompletion: { (completion) in
        switch completion {
        case .failure(_):
          completionFailureExpectation.fulfill()
        case .finished:
          completionFinishedExpectation.fulfill()
        }
      }) { (account) in
        valueReceivedExpectation.fulfill()
      }
    .cancel()
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testPostRequestWithErrorReturnsError() {
    URLProtocolMock.testURLs = [:]
    URLProtocolMock.response = networkResponseMocks.invalidResponse
    
    let valueReceivedExpectation = self.expectation(description: "value received expectation")
    valueReceivedExpectation.isInverted = true
    
    let completionFinishedExpectation = self.expectation(description: "completion finished expectation")
    completionFinishedExpectation.isInverted = true
    
    let completionFailureExpectation = self.expectation(description: "completion failure expectation")
    
    let request: AnyPublisher<Account, NetworkError> = networkAPI.postRequest(router: EosioRouter.getAccount, httpBody: Data("".utf8))
    
    request
      .sink(receiveCompletion: { (completion) in
        switch completion {
        case .failure(_):
          completionFailureExpectation.fulfill()
        case .finished:
          completionFinishedExpectation.fulfill()
        }
      }) { (account) in
        valueReceivedExpectation.fulfill()
      }
    .cancel()
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testPostRequestWithProperResponseButErrorJsonReturnsError() {
    let url = URL(string: "https://api.eosn.io/v1/chain/get_account?")
    URLProtocolMock.testURLs = [url: Data("".utf8)]
    
    URLProtocolMock.response = networkResponseMocks.validResponse
    
    let valueReceivedExpectation = self.expectation(description: "value received expectation")
    valueReceivedExpectation.isInverted = true
    
    let completionFinishedExpectation = self.expectation(description: "completion finished expectation")
    completionFinishedExpectation.isInverted = true
    
    let completionFailureExpectation = self.expectation(description: "completion failure expectation")
    
    let request: AnyPublisher<Account, NetworkError> = networkAPI.postRequest(router: EosioRouter.getAccount, httpBody: Data("".utf8))
    
    request
      .sink(receiveCompletion: { (completion) in
        switch completion {
        case .failure(_):
          completionFailureExpectation.fulfill()
        case .finished:
          completionFinishedExpectation.fulfill()
        }
      }) { (account) in
        valueReceivedExpectation.fulfill()
      }
    .cancel()
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
}
