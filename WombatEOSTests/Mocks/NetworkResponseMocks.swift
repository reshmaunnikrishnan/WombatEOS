//
//  NetworkResponseMocks.swift
//  WombatEOSTests
//
//  Created by Reshma Unnikrishnan on 20.01.20.
//  Copyright © 2020 ruvlmoon. All rights reserved.
//

import Foundation

class NetworkResponseMocks {
  let invalidResponse = URLResponse(url: URL(string: "https://api.eosn.io/v1/chain/get_account?")!,
                                    mimeType: nil,
                                    expectedContentLength: 0,
                                    textEncodingName: nil)
  
  let validResponse = HTTPURLResponse(url: URL(string: "https://api.eosn.io/v1/chain/get_account?")!,
                                      statusCode: 200,
                                      httpVersion: nil,
                                      headerFields: nil)
  
  let invalidResponse300 = HTTPURLResponse(url: URL(string: "https://api.eosn.io/v1/chain/get_account?")!,
                                           statusCode: 300,
                                           httpVersion: nil,
                                           headerFields: nil)
  let invalidResponse401 = HTTPURLResponse(url: URL(string: "https://api.eosn.io/v1/chain/get_account?")!,
                                           statusCode: 401,
                                           httpVersion: nil,
                                           headerFields: nil)
  
  let networkError = NSError(domain: "NSURLErrorDomain", code: -1004, userInfo: nil)
  
}
