//
//  Profile.swift
//  LectureFeed
//


import Foundation

// This model represents the user & its account type + name

class Profile {
	var isHost: Bool
	var name: String
	var email: String
	var lectureList: [Lecture]?
	
	init(isHost: Bool, name: String, email: String) {
		self.isHost = isHost
		self.name = name
		self.email = email
	}
}
