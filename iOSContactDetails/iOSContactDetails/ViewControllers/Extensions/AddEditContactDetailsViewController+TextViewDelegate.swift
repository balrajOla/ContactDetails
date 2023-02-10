//
//  AddEditContactDetailsViewController+TextViewDelegate.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 31/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit

extension AddEditContactDetailsViewController: UITextFieldDelegate {
    func setUpTextFieldDelegate() {
        self.firstNameTextView.delegate = self
        self.lastNametextView.delegate = self
        self.emailTextView.delegate = self
        self.mobileTextView.delegate = self
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        KeyboardAvoiding.avoidingView = textField
        return true
    }
}
