//
//  ContactDetailViewController+MessageUI.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 31/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit
import MessageUI

extension ContactDetailViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
    
    func sendMessage(to: String) -> (_ message: String?) -> Bool  {
        return { (_ message: String?) -> Bool in
            let composeVC = MFMessageComposeViewController()
            
            // Configure the fields of the interface.
            composeVC.recipients = [self.viewModel.getMobileNumber()]
            composeVC.body = message
            
            // Present the view controller modally.
            if MFMessageComposeViewController.canSendText() {
                self.present(composeVC, animated: true, completion: nil)
                return true
            } else {
                self.showToast(message: "Message sending is disabled on this device")
                return false
            }
        }
    }
}

extension ContactDetailViewController: MFMailComposeViewControllerDelegate  {
    func sendEmail(to: String) -> (_ message: String?) -> Bool  {
        return { (_ message: String?) -> Bool in
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([to])
                message.map { mail.setMessageBody($0, isHTML: true) }
                
                self.present(mail, animated: true)
                return true
            } else {
                self.showToast(message: "Email is disabled on this device")
                return false
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
