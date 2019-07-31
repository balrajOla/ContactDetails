//
//  ContactDetailViewController.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 29/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit
import AlamofireImage

class ContactDetailViewController: UIViewController {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var emailID: UILabel!
    @IBOutlet weak var mobileNumber: UILabel!
    @IBOutlet weak var grdientView: GradientView!
    @IBOutlet weak var favorite: UIButton!
    
    let viewModel: ContactDetailsViewModel
    
    init(withViewModel vm: ContactDetailsViewModel) {
        self.viewModel = vm
        super.init(nibName: String.stringFromClass(ContactDetailViewController.self), bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        grdientView.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Details"
        self.addRightNavigationBarItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.bindData()
        Loader.show(blockingLoader: false)
        self.viewModel.loadContactDetails()
            .done(on: DispatchQueue.main) { _ in self.bindData() }
            .catch { err in
                self.showToast(message: "Something went wrong please try again")
                print(err)
            }
            .finally(on: DispatchQueue.main) {
                Loader.hide()
        }
    }
    
    @IBAction func clickedMessage(_ sender: Any) {
        if !self.viewModel.isMobileNumberEmpty() {
            _ = (self.viewModel.getMobileNumber() |> self.sendMessage(to:))(nil)
        } else { self.showToast(message: "Please add mobile number") }
    }
    
    @IBAction func clickedCall(_ sender: Any) {
        if !self.viewModel.isMobileNumberEmpty() {
            if !(self.viewModel.getMobileNumber() |> call(mobNumber:)) {
                self.showToast(message: "Calling facility is disabled on this device")
            }
        } else { self.showToast(message: "Please add mobile number") }
    }
    
    @IBAction func clickedEmail(_ sender: Any) {
        if !self.viewModel.isEmailIDEmpty() {
          _ = (self.viewModel.getEmailID() |> sendEmail(to:))(nil)
        } else { self.showToast(message: "Please add email id") }
    }
    
    @IBAction func toggleFav(_ sender: Any) {
        Loader.show(blockingLoader: false)
        self.viewModel.toggleIsFav()
            .done(on: DispatchQueue.main) { isFav in
                self.showToast(message: isFav ? "This contact is added to your favorite" : "This contact is removed from your contact")
                
                self.bindData() }
            .catch { err in
                self.showToast(message: "Something went wrong please try again")
                print(err)
            }
            .finally(on: DispatchQueue.main) {
                Loader.hide()
        }
    }
    
    private func addRightNavigationBarItems() {
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editContactDetail)), animated: true)
    }
    
    @objc private func editContactDetail() {
        self.viewModel.getAddEditContactDetailViewModel()
            |> AddEditContactDetailsViewController.init(withViewModel:)
            >>> {[weak self] (vc: AddEditContactDetailsViewController)  -> Void in
                self?.navigationController?.pushViewController(vc, animated: true) }
    }
    
    private func bindData() {
        // set profile pic
        if let imageUrl = viewModel.profilePic() {
            self.profilePic.af_setImage(withURL: imageUrl, placeholderImage: UIImage(imageLiteralResourceName: "profileDefaultPic"))
        } else {
            self.profilePic.image = UIImage(imageLiteralResourceName: "profileDefaultPic")
        }
        
        // set name
        self.name.text = self.viewModel.getFullName()
        
        //set emailID and phone number
        self.mobileNumber.text = self.viewModel.getMobileNumber()
        self.emailID.text = self.viewModel.getEmailID()
        
        // set fav btn text
        self.favorite.setTitle(self.viewModel.getFavStatus() ? "Favourite" : "Unfavourite", for: .normal)
    }
}
