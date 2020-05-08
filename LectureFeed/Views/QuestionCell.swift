//
//  QuestionCell.swift
//  LectureFeed
//
//  Created by Silin Chen on 5/8/20.
//  Copyright © 2020 Silin Chen. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {

	@IBOutlet weak var senderAndDateLabel: UILabel!
	@IBOutlet weak var bodyTextTF: UITextView!
	
	func setCell(sender: String, date: Date, bodyText: String) {
		senderAndDateLabel.text = "From " + sender + ": "
		bodyTextTF.text = bodyText
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
