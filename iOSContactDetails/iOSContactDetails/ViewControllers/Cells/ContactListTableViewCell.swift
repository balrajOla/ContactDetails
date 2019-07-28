//
//  ContactListTableViewCell.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 29/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit
import AlamofireImage

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
        
        if let imageUrl = viewModel.flatMap({ $0.profilePic() }) {
            self.profilePic.af_setImage(withURL: imageUrl, placeholderImage: UIImage(imageLiteralResourceName: "profileDefaultPic"))
        } else {
            self.profilePic.image = UIImage(imageLiteralResourceName: "profileDefaultPic")
        }
    }
}
