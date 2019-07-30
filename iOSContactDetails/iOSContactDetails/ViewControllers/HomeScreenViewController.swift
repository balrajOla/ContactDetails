//
//  HomeScreenViewController.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 26/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    let viewModel = ContactListViewModel(usecase: ContactsUsecase())

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Contacts"
        self.addRightNavigationBarItems()
        self.setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.viewModel.hasNoData() { Loader.show(blockingLoader: false) }
        self.viewModel.loadContacts()
            .done(on: DispatchQueue.main) { _ in self.tableView.reloadData() }
            .catch { err in print(err.localizedDescription) }
            .finally(on: DispatchQueue.main) {
                Loader.hide()
        }
    }
    
    private func addRightNavigationBarItems() {
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContactDetail)), animated: true)
    }
    
    @objc private func addContactDetail() {
        self.viewModel.getAddEditContactDetailViewModel()
        |> AddEditContactDetailsViewController.init(withViewModel:)
            >>> {[weak self] (vc: AddEditContactDetailsViewController)  -> Void in
                self?.navigationController?.pushViewController(vc, animated: true) }
    }
}
