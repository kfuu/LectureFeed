//
//  HomeVC.swift
//  LectureFeed
//
//  Created by Silin Chen on 5/1/20.
//  Copyright © 2020 Silin Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SwiftSocket

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var profileModel: Profile?
	var tuplePassed: (String, String)?
	var passcodeTextField: UITextField?
	var lectureIDtoPass: String?
	
	let labels = ["label1", "label2", "label3", "label4", "label4", "label4", "label4", "label4", "label4", "label4", "label4", "label4", "label4", "label4"] // [String]()

	@IBOutlet weak var homeLabel: UILabel!
	@IBOutlet weak var lectureCollection: UICollectionView!
	
	/*               */
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		//profileModel = Profile(isHost: false, name: tuplePassed!.0, email: tuplePassed!.1) // initialization
		
		let user = Auth.auth().currentUser
		if let user = user {
			//print(user.email)
			db.collection("Users").document(user.email!).getDocument(completion: { (document, error) in
				if let document = document, document.exists {
					let name = document.get("Name") as! String
					let isLecturer = document.get("isLecturer") as! Bool
					let email = document.get("Email") as! String
					self.profileModel = Profile(isHost: isLecturer, name: name, email: email)
					
					self.homeLabel.text = "Welcome, " + name
				}
				else {
					print("Document does not exist")
				}
			})
		}
		
		//homeLabel.text = "Welcome, " + (profileModel?.name ?? "error")
		//homeLabel.text = "Welcome, " + (tuplePassed?.0 ?? "error")
		
		lectureCollection.dataSource = self
		lectureCollection.delegate = self
    }
    
	@IBAction func connectToLecture(_ sender: Any) {
		if self.profileModel!.isHost {
			//print("testing! lecturer will generate new code here.")
			var ref: DocumentReference? = nil
			ref = db.collection("Lectures").addDocument(data: [:]) {
				err in
				if let err = err {
					print("Error adding document: \(err)")
				}
				else {
					print("ID is: \(ref!.documentID)")
				}
			}
			
			let lectureID: String = ref!.documentID
			let new_lectureID: String = String(lectureID.prefix(5))
			self.lectureIDtoPass = new_lectureID
			
			let alertController = UIAlertController(title: "Lecture ID: \(new_lectureID)", message: "Please distribute this lecture ID code to the lecturees. Don't press OK until you are ready to proceed.", preferredStyle: .alert)
			let okAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
				print("cool")
				
				self.performSegue(withIdentifier: "toLecture", sender: self)
			})
			alertController.addAction(okAction)
			
			self.present(alertController, animated: true)
			//"question1" : ["body": "new stuff", "sender": "hello"
			
		}
		else {
			let alertController = UIAlertController(title: "Connect", message: "Please enter the lecture code:", preferredStyle: .alert)
			alertController.addTextField(configurationHandler: passcodeTextFieldHandler)
			
			let okAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
				// if passcode is entered incorrectly, prompt retry
				// else, segue to next vc
				
				db.collection("Lectures").getDocuments() {(querySnapshot, error) in
					if let error = error {
						print("Error getting documents: \(error)")
					}
					else {
						var lectureFound = false
						for document in querySnapshot!.documents {
							if String((document.documentID).prefix(5)) == self.passcodeTextField?.text { // take care of time issues in the future. for now, IDs probably won't ever match due to randomness.
								lectureFound = true
								self.performSegue(withIdentifier: "toLecture", sender: self)
								break
							}
						}
						if !lectureFound {
							let codeFailureAlert = UIAlertController(title: nil, message: "Your passcode was not matched to any lectures. Please try again.", preferredStyle: .alert)
							let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
							codeFailureAlert.addAction(okAction)
							self.present(codeFailureAlert, animated: true)
						}
					}
					
					// print passcode failed here
				}
			})
			let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
			alertController.addAction(okAction)
			alertController.addAction(cancelAction)
			
			self.present(alertController, animated: true)
		}
	}
	
	func passcodeTextFieldHandler(textField: UITextField!) {
		passcodeTextField = textField
		passcodeTextField?.placeholder = "Passcode"
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return labels.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lectureCell", for: indexPath) as! LectureCell
		cell.lectureCellLabel.text = labels[indexPath.item]
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print(indexPath.item)
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is FeedVC {
			// pass the profile object
			let vc = segue.destination as? FeedVC
			vc?.modalPresentationStyle = .fullScreen // maybe? could be affected by nav vc
			vc?.profileModel = self.profileModel
			vc?.lectureID = self.lectureIDtoPass
		}
	}

}
