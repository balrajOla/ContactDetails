//
//  AddEditContactDetailsViewController.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 30/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit
import AlamofireImage

class AddEditContactDetailsViewController: UIViewController {
    @IBOutlet weak var firstNameTextView: UITextField!
    @IBOutlet weak var lastNametextView: UITextField!
    @IBOutlet weak var mobileTextView: UITextField!
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var gradientView: GradientView!
    let viewModel: AddEditContactDetailsViewModel
    
    init(withViewModel vm: AddEditContactDetailsViewModel) {
        self.viewModel = vm
        super.init(nibName: String.stringFromClass(AddEditContactDetailsViewController.self), bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addNavigationBarItems()
        self.setUpTextFieldDelegate()
        self.bindData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientView.setNeedsDisplay()
        self.title = self.viewModel.getTitle()
    }
    
    private func addNavigationBarItems() {
        self.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelContactDetail)), animated: true)
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addContactDetail)), animated: true)
    }
    
    private func bindData() {
        self.firstNameTextView.text = self.viewModel.getFirstName()
        self.lastNametextView.text = self.viewModel.getLastName()
        self.emailTextView.text = self.viewModel.getEmailID()
        self.mobileTextView.text = self.viewModel.getPhoneNumber()
        
        // set profile pic
        if let imageUrl = viewModel.profilePic() {
            self.profilePicImageView.af_setImage(withURL: imageUrl, placeholderImage: UIImage(imageLiteralResourceName: "profileDefaultPic"))
        } else {
            self.profilePicImageView.image = UIImage(imageLiteralResourceName: "profileDefaultPic")
        }
    }
    
    @objc private func addContactDetail() {
        Loader.show(blockingLoader: true)
       self.viewModel.saveContactDetails()
        .done(on: DispatchQueue.main) { value in
            self.showToast(message: value)
            self.cancelContactDetail()
        }
        .catch { error in
            self.showToast(message: error.localizedDescription) }
        .finally(on: DispatchQueue.main) {
            Loader.hide()
        }
    }
    
    @objc private func cancelContactDetail() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Text did change
    @IBAction func firstNameTextChanged(_ sender: UITextField) {
        (sender.text ?? "") |> self.viewModel.setFirstName(name:)
    }
    
    @IBAction func lastNameTextChange(_ sender: UITextField) {
        (sender.text ?? "") |> self.viewModel.setLastName(name:)
    }
    
    @IBAction func mobileTextChange(_ sender: UITextField) {
        (sender.text ?? "") |> self.viewModel.setPhoneNumber(number:)
    }
    
    @IBAction func emailTextChange(_ sender: UITextField) {
        (sender.text ?? "") |> self.viewModel.setEmailID(email:)
    }
}
