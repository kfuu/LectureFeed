//
//  LectureCell.swift
//  LectureFeed
//


import UIKit

class LectureCell: UICollectionViewCell {
	@IBOutlet weak var lectureCellLabel: UILabel!
	
	func setCell(labelText: String!) {
		self.lectureCellLabel.text = labelText
	}
}
