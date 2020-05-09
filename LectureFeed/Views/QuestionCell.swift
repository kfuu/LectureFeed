//
//  QuestionCell.swift
//  LectureFeed
//


import UIKit

class QuestionCell: UITableViewCell {

	@IBOutlet weak var senderAndDateLabel: UILabel!
	@IBOutlet weak var bodyTextTF: UITextView!
	
	func setCell(sender: String, date: Date, bodyText: String) {
		senderAndDateLabel.text = "From " + sender + ": "
		bodyTextTF.text = bodyText
	}
}
