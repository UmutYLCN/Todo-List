//
//  UITextField+Extension.swift
//  todo
//
//  Created by umut yalçın on 22.03.2023.
//

import Foundation
import UIKit
import SnapKit


extension UITextField {
    
    func toStyledTxtField() { // Give Round Border and Left Placholder Padding
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        self.leftViewMode = UITextField.ViewMode.always
    }
}

