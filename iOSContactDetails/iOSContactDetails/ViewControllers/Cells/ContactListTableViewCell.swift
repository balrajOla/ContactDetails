//
//  ContactListTableViewCell.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 29/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {
    var viewModel: ContactCellViewModel?

    @IBOutlet weak var favIcon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(viewModel: ContactCellViewModel) {
        self.viewModel = viewModel
        self.setupDataToView()
    }
    
    private func setupDataToView() {
        self.name.text = self.viewModel?.getName()
        self.favIcon.isHidden = !(self.viewModel?.isFav() ?? false)
        self.profilePic.image = self.viewModel?.profilePic().flatMap { url -> UIImage? in (try? Data.init(contentsOf:url)).flatMap { UIImage(data: $0) } }
    }
}
