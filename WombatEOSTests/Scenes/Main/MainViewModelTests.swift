//
//  MainViewModelTests.swift
//  WombatEOSTests
//
//  Created by Reshma Unnikrishnan on 21.01.20.
//  Copyright © 2020 ruvlmoon. All rights reserved.
//

import XCTest
import Combine
@testable import WombatEOS

class MockEosioService: EosioServiceType {
  var account: Account?
  var error: NetworkError?
  
  func getAccount(accountName: String) -> AnyPublisher<Account, NetworkError> {
    if let account = account {
      return Just(
          account
      ).mapError({ (error) -> NetworkError in
        .routerError
      })
      .eraseToAnyPublisher()
    } else {
      return Fail(error: error!).eraseToAnyPublisher()
    }
  }
}

class MainViewModelTests: XCTestCase {
  
  var viewModel: MainViewModel!
  var service: MockEosioService!
  var networkAPI: MockNetworkAPI!
  
  override func setUp() {
    service = MockEosioService()
    viewModel = MainViewModel(service: service)
  }
  
  override func tearDown() {
    viewModel = nil
    service = nil
  }
  
  func testViewModelStateShowsFinishedAndAccountIsReturnedWhenTheAccountExists() {
    let account = Account(accountName: "genialwombat",
                          balance: "636800",
                          ramUsage: 456.9,
                          ramQuota: 900.0,
                          netLimit: Account.NetLimit(used: 2.99, available: 3.65, max: 3.00),
                          cpuLimit: Account.CPULimit(used: 3.33, available: 5.55, max: 4.50))
    
    service.account = account
    
    viewModel.accountResults(forAccount: "test")
    
    XCTAssertEqual(viewModel.state, ViewModelState.finishedLoading)
    XCTAssertEqual(viewModel.accountViewModel?.account, account)
  }
  
  func testViewModelStateShowsFailureAndErrorIsReturnedWhenTheAccountDoesNotExist() {
    service.error = NetworkError.routerError
    
    viewModel.accountResults(forAccount: "test")
    
    XCTAssertEqual(viewModel.state, ViewModelState.error(NetworkError.routerError))
    XCTAssertNil(viewModel.accountViewModel?.account)
  }
}
