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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
