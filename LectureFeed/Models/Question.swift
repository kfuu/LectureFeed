//
//  Question.swift
//  LectureFeed
//
//  Created by Silin Chen on 5/8/20.
//  Copyright © 2020 Silin Chen. All rights reserved.
//

import Foundation
import UIKit

class Question {
	var sender: String?
	var bodyText: String?
	var date: Date?
	var numLikes: Int?
	
	init(sender: String, bodyText: String, date: Date, numLikes: Int) {
		self.sender = sender
		self.bodyText = bodyText
		self.date = date
		self.numLikes = numLikes
	}
}
