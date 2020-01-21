//
//  UITextField+Publisher.swift
//  WombatEOS
//
//  Created by Reshma Unnikrishnan on 19.01.20.
//  Copyright © 2020 ruvlmoon. All rights reserved.
//

// From https://github.com/mcichecki/Combine-MVVM/blob/master/CombineDemo/Combine/UITextField%2BPublisher.swift

import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}
