//
//  ListPeopleCell.swift
//  Rubbrica
//
//  Created by stefano vecchiati on 24/09/2018.
//  Copyright © 2018 co.eggon. All rights reserved.
//

import UIKit

class ListPeopleCell: UITableViewCell {
    
    @IBOutlet weak var imageProfile: UIImageView! {
        didSet {
            imageProfile.layer.cornerRadius = imageProfile.frame.width / 2
            imageProfile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameProfile: UILabel!
    
    static let kIdentifier = "ListPeopleCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
