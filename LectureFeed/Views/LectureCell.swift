//
//  LectureCell.swift
//  LectureFeed
//
//  Created by Silin Chen on 5/1/20.
//  Copyright © 2020 Silin Chen. All rights reserved.
//

import UIKit

class LectureCell: UICollectionViewCell {
	@IBOutlet weak var lectureCellLabel: UILabel!
	
	func setCell(labelText: String!) {
		self.lectureCellLabel.text = labelText
	}
}
