    //
    //  UIViewController+Toast.swift
    //  iOSContactDetails
    //
    //  Created by Balraj Singh on 30/07/19.
    //  Copyright © 2019 Balraj Singh. All rights reserved.
    //
    
    import UIKit
    extension UIViewController {
        
        func showToast(message : String) {
            
            let toastLabel = UILabel(frame: CGRect(x: 10, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 20, height: 35))
            toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            toastLabel.textColor = UIColor.black
            toastLabel.textAlignment = .center;
            toastLabel.font = UIFont.systemFont(ofSize: 10)
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            UIApplication.shared.keyWindow?.addSubview(toastLabel)
            UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        } }
