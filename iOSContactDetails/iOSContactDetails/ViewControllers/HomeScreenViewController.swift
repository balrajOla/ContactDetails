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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Contacts"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Loader.show(blockingLoader: false)
        self.viewModel.loadContacts()
            .done(on: DispatchQueue.main) { _ in
                
            }
            .catch { _ in }
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
