//
//  AccountViewModelTests.swift
//  WombatEOSTests
//
//  Created by Reshma Unnikrishnan on 20.01.20.
//  Copyright © 2020 ruvlmoon. All rights reserved.
//

import XCTest
@testable import WombatEOS

class AccountViewModelTests: XCTestCase {
  
  private var subject: AccountViewModel!
  override func setUp() {
    let account = Account(accountName: "genialwombat",
                          balance: "636800",
                          ramUsage: 456.9,
                          ramQuota: 900.0,
                          netLimit: Account.NetLimit(used: 2.99, available: 3.65, max: 3.00),
                          cpuLimit: Account.CPULimit(used: 3.33, available: 5.55, max: 4.50))
    subject = AccountViewModel(account: account)
  }
  
  override func tearDown() {
    subject = nil
  }
  
  func testAccountNameReturnsCorrectly() {
    XCTAssertEqual(subject.accountNameText, "genialwombat")
    XCTAssertEqual(subject.balanceText, "636800")
    XCTAssertEqual(subject.netLimitUsageText, "2.99 KB / 3.65 KB")
    XCTAssertEqual(subject.cpuLimitUsageText, "3.33 KB / 5.55 KB")
    XCTAssertEqual(subject.ramUsageText, "456.9 ms / 900.0 ms")
  }
}
