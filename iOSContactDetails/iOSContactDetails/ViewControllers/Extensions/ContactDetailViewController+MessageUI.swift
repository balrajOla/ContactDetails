//
//  ContactDetailViewController+MessageUI.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 31/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit
import MessageUI

extension ContactDetailViewController {
    func displayMessageInterface() {
        if self.viewModel.isMobileNumberEmpty() {
            self.showToast(message: "Please add mobile number before sending messages")
            
            return
        }
        
        let composeVC = MFMessageComposeViewController()
        
        // Configure the fields of the interface.
        composeVC.recipients = [self.viewModel.getMobileNumber()]
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
           self.showToast(message: "Message sending is disabled on this device")
        }
    }
}
