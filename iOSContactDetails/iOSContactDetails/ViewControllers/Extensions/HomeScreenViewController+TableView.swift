//
//  HomeScreenViewController+TableView.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 29/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit

extension HomeScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getTotalContactsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: String.stringFromClass(ContactListTableViewCell.self), for: indexPath as IndexPath)
        
        (myCell as? ContactListTableViewCell).map {[weak self] cell -> Void in
            guard let self = self else { return }
            self.viewModel.getContactCellViewModel(forIndex: indexPath.row).map(cell.setUp(viewModel:)) }
        
        return myCell
    }
    
    func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerCells([ContactListTableViewCell.self], bundle: Bundle.main)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 64
    }
}

extension HomeScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPath.row
            |> self.viewModel.getContactDetailsViewModel(forIndex:)
            >>> { $0.map { $0
                |> ContactDetailViewController.init(withViewModel:)
                >>> {[weak self] (vc: ContactDetailViewController)  -> Void in
                    self?.navigationController?.pushViewController(vc, animated: true) } } }
    }
}
