//
//  ViewController.swift
//  WombatEOS
//
//  Created by Reshma Unnikrishnan on 19.01.20.
//  Copyright © 2020 ruvlmoon. All rights reserved.
//

import UIKit
import Combine


class MainViewController: UIViewController {
  
  @IBOutlet weak var accountNameField: UITextField!
  @IBOutlet weak var showWalletButton: UIButton!
  
  var viewModel: MainViewModel = MainViewModel()
  var accountNamePublisher: AnyPublisher<String, Never>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpTargets()
    setUpBindings()
  }
  
  private func setUpBindings() {
    _ = viewModel
      .$accountViewModel
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (accountViewModel) in
        guard let viewModel = accountViewModel else { return }
        guard let self = self else { return }
        
        //push to Account View Controller
        self.showAccountView(viewModel: viewModel)
    }
    
    _ = viewModel
      .$state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (state) in
        switch state {
        case .loading:
          self?.displayActivityIndicator(shouldDisplay: true)
        case .finishedLoading, .ready:
          self?.displayActivityIndicator(shouldDisplay: false)
        case .error(let err):
          self?.displayActivityIndicator(shouldDisplay: false)
          
          //show AlertView
          self?.showAlertView(error: err)
        }
    }
  }
  
  private func setUpTargets() {
    showWalletButton.addTarget(self, action: #selector(accessWallet), for: .touchUpInside)
  }
  
  private func showAccountView(viewModel: AccountViewModel) {
    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AccountViewController") as? AccountViewController
    guard let accountVC = vc else { return }
    
    accountVC.viewModel = viewModel
    self.navigationController?.pushViewController(accountVC, animated: true)
  }
  
  private func showAlertView(error: Error) {
    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  @objc private func accessWallet() {
    viewModel
      .accountResults(forAccount: accountNameField.text ?? "")
  }
}

