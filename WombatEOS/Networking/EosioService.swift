//
//  EosioService.swift
//  WombatEOS
//
//  Created by Reshma Unnikrishnan on 19.01.20.
//  Copyright © 2020 ruvlmoon. All rights reserved.
//

import Foundation
import Combine

protocol EosioServiceType {
  func getAccount(accountName: String) -> AnyPublisher<Account, NetworkError>
}

class EosioService: EosioServiceType {
  var networkAPI: NetworkAPIType
  
  init(networkAPI: NetworkAPIType = NetworkAPI()) {
    self.networkAPI = networkAPI
  }
  
  func getAccount(accountName: String) -> AnyPublisher<Account, NetworkError> {
    var dict: [String: String] = [:]
    dict["account_name"] = accountName
    
    do {
      let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
      
      return networkAPI.postRequest(router: EosioRouter.getAccount, httpBody: data)
    } catch {
      return Fail(error: NetworkError.routerError).eraseToAnyPublisher()
    }
  }
}

