//
//  FBFeedCell.swift
//  SocialFeed
//
//  Created by Rajender Sharma on 26/06/20.
//  Copyright © 2020 Rajender Sharma. All rights reserved.
//

import UIKit

class FBFeedCell: UITableViewCell {

	@IBOutlet weak var feedImage:UIImageView! {
		didSet {
			feedImage.contentMode = .scaleAspectFit
			feedImage.clipsToBounds = true
            feedImage.backgroundColor = UIColor.white
		}
	}

	@IBOutlet weak var titleLabel:UILabel! {
		didSet {
			titleLabel.font = UIFont.systemFont(ofSize: 18)
			titleLabel.textColor = .black
			titleLabel.numberOfLines = 0
		}
	}

	@IBOutlet weak var detailLabel:UILabel! {
		didSet {
			detailLabel.font = UIFont.systemFont(ofSize: 15)
			detailLabel.textColor = .darkGray
			detailLabel.numberOfLines = 0
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
