//
//  EosioRouter.swift
//  WombatEOS
//
//  Created by Reshma Unnikrishnan on 19.01.20.
//  Copyright © 2020 ruvlmoon. All rights reserved.
//

import Foundation

enum EosioRouter {
  case getAccount
}

extension EosioRouter {
  var scheme: String {
    switch self {
    case .getAccount:
      return "https"
    }
  }
  
  var host: String {
    switch self {
    case .getAccount:
      return "api.eosn.io"
    }
  }
  
  var path: String {
    switch self {
    case .getAccount:
      return "/v1/chain/get_account"
    }
  }
  
  var parameters: [URLQueryItem] {
    switch self {
    case .getAccount:
      return []
    }
  }
}
