//
//  AccountViewModel.swift
//  WombatEOS
//
//  Created by Reshma Unnikrishnan on 19.01.20.
//  Copyright © 2020 ruvlmoon. All rights reserved.
//

import Foundation

class AccountViewModel {
  @Published var accountNameText: String = ""
  @Published var balanceText: String = ""
  @Published var ramUsageProgress: Float = 0
  @Published var ramUsageText: String = ""
  @Published var netLimitUsageText: String = ""
  @Published var netUsageProgress: Float = 0
  @Published var cpuLimitUsageText:  String = ""
  @Published var cpuUsageProgress: Float = 0

  var account: Account
  
  init(account: Account) {
    self.account = account
    setUpBindings()
  }
  
  private func setUpBindings() {
    accountNameText = account.accountName
    balanceText = account.balance
    
    ramUsageProgress = (account.ramUsage / account.ramQuota)
    ramUsageText = String(describing: "\(account.ramUsage) ms / \(account.ramQuota) ms")
    
    cpuUsageProgress = (account.cpuLimit.used / account.cpuLimit.available)
    cpuLimitUsageText = String(describing: "\(account.cpuLimit.used) KB / \(account.cpuLimit.available) KB")
    
    netUsageProgress =  (account.netLimit.used / account.netLimit.available)
    netLimitUsageText = String(describing: "\(account.netLimit.used) KB / \(account.netLimit.available) KB")
  }
}
