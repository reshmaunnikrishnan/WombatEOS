//
//  MainViewModel.swift
//  WombatEOS
//
//  Created by Reshma Unnikrishnan on 19.01.20.
//  Copyright © 2020 ruvlmoon. All rights reserved.
//

import Foundation
import Combine

enum ViewModelState: Equatable {
  case ready
  case loading
  case finishedLoading
  case error(NetworkError)
  
  public static func == (a: ViewModelState, b: ViewModelState) -> Bool {
    switch (a,b) {
    case (.loading, .loading),
         (.finishedLoading, .finishedLoading),
         (.error(NetworkError.routerError), .error(NetworkError.routerError)),
         (.error(NetworkError.decode(_)), .error(NetworkError.decode(_))),
         (.error(NetworkError.url(_)), .error(NetworkError.url(_))) :
      return true
      
    default: return false
    }
  }
}

protocol MainViewModelType {
  func accountResults(forAccount name: String)
}

final class MainViewModel: ObservableObject, Identifiable {
  @Published private(set) var state: ViewModelState = .ready
  @Published private(set) var accountViewModel: AccountViewModel?
  
  private let service: EosioServiceType
  
  init(service: EosioServiceType = EosioService()) {
    self.service = service
  }
  
  func accountResults(forAccount name: String) {
    state = .loading
    
    service
      .getAccount(accountName: name)
      .sink(receiveCompletion: { [weak self] (completion) in
        switch completion {
        case .failure(let error):
          self?.state = .error(error)
        case .finished:
          self?.state = .finishedLoading
        }
      }) { [weak self] account in
        self?.accountViewModel = AccountViewModel(account: account)
      }
      .cancel()
  }
}
