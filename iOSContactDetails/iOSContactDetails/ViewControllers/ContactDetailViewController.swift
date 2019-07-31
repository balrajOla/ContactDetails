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
                print(err)
            }
            .finally(on: DispatchQueue.main) {
                Loader.hide()
        }
    }
    
    @IBAction func clickedMessage(_ sender: Any) {
        self.displayMessageInterface()
    }
    
    @IBAction func clickedCall(_ sender: Any) {
    }
    
    @IBAction func clickedEmail(_ sender: Any) {
    }
    
    @IBAction func toggleFav(_ sender: Any) {
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
    }
}
