//
//  AccountViewController.swift
//  WombatEOS
//
//  Created by Reshma Unnikrishnan on 19.01.20.
//  Copyright © 2020 ruvlmoon. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
  
  
  @IBOutlet weak var netText: UILabel!
  @IBOutlet weak var netProgress: UIProgressView!
  
  @IBOutlet weak var cpuText: UILabel!
  @IBOutlet weak var cpuProgress: UIProgressView!
  
  @IBOutlet weak var ramText: UILabel!
  @IBOutlet weak var ramProgress: UIProgressView!
  
  @IBOutlet weak var balance: UILabel!
  @IBOutlet weak var balanceInDollars: UILabel!
  
  var viewModel: AccountViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setBackGround()
  }
  
  func setupUI() {
    
    self.title = viewModel?.accountNameText
    netText.text = viewModel?.netLimitUsageText
    netProgress.progress = viewModel?.netUsageProgress ?? 0
    cpuText.text = viewModel?.cpuLimitUsageText
    cpuProgress.progress = viewModel?.cpuUsageProgress ?? 0
    ramText.text = viewModel?.ramUsageText
    ramProgress.progress = viewModel?.ramUsageProgress ?? 0
    self.balance.text = viewModel?.balanceText
  }
  
  func setBackGround() {
    let gradient = CAGradientLayer()
    gradient.frame = self.view.bounds
    gradient.colors = [UIColor.orange.cgColor, UIColor.white.cgColor]
    self.view.layer.insertSublayer(gradient, at: 0)
  }
  
}
