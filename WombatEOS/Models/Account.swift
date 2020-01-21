//
//  Account.swift
//  WombatEOS
//
//  Created by Reshma Unnikrishnan on 19.01.20.
//  Copyright © 2020 ruvlmoon. All rights reserved.
//

import Foundation

struct Account: Equatable {
  let accountName: String
  let balance: String
  let ramUsage: Float
  let ramQuota: Float
  let netLimit: NetLimit
  let cpuLimit: CPULimit
  
  
  struct NetLimit: Decodable {
    let used: Float
    let available: Float
    let max: Float
  }
  
  struct CPULimit: Decodable {
    let used: Float
    let available: Float
    let max: Float
  }
}

extension Account: Decodable {
  private enum CodingKeys : String, CodingKey {
      case accountName = "account_name",
        balance = "core_liquid_balance",
        netLimit = "net_limit",
        cpuLimit = "cpu_limit",
        ramUsage = "ram_usage",
        ramQuota = "ram_quota"
  }
}

func ==(lhs: Account, rhs: Account) -> Bool {
  return lhs.accountName == rhs.accountName
}
