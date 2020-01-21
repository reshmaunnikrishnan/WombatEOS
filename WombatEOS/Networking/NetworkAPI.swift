//
//  NetworkAPI.swift
//  WombatEOS
//
//  Created by Reshma Unnikrishnan on 19.01.20.
//  Copyright © 2020 ruvlmoon. All rights reserved.
//

import Foundation
import Combine

public enum NetworkError: Error {
  case url(URLError)
  case decode(Error)
  case routerError
}

protocol NetworkAPIType {
  func postRequest<T: Decodable>(router: EosioRouter, httpBody: Data) -> AnyPublisher<T, NetworkError>
}

class NetworkAPI: NetworkAPIType {
  var urlSession: URLSession
  var decoder: JSONDecoder
  
  init(urlSession: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
    self.urlSession = urlSession
    self.decoder = decoder
  }
  
  func postRequest<T: Decodable>(router: EosioRouter, httpBody: Data) -> AnyPublisher<T, NetworkError> {
    var components = URLComponents()
    components.scheme = router.scheme
    components.host = router.host
    components.path = router.path
    components.queryItems = router.parameters
    
    guard let url = components.url else {
      return Fail(error: NetworkError.routerError).eraseToAnyPublisher()
    }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.httpBody = httpBody
    
    urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
    urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
    
    return run(urlRequest)
  }
  
  func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, NetworkError> {
    return urlSession
      .dataTaskPublisher(for: request)
      .retry(1)
      .mapError { NetworkError.url($0) }
      .map { $0.data }
      .decode(type: T.self, decoder: self.decoder)
      .mapError { NetworkError.decode($0) }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
