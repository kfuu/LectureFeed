//
//  Profile.swift
//  LectureFeed
//
//  Created by Silin Chen on 5/1/20.
//  Copyright © 2020 Silin Chen. All rights reserved.
//

import Foundation

// This model represents the user & its account type + name

class Profile {
	var isHost: Bool
	var name: String
	var lectureList: [Lecture]?
	
	init(isHost: Bool, name: String) {
		self.isHost = isHost
		self.name = name
	}
}
