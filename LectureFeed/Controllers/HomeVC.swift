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

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var profileModel: Profile?
	var tuplePassed: (String, String)?
	var passcodeTextField: UITextField?
	
	let labels = ["label1", "label2", "label3", "label4", "label4", "label4", "label4", "label4", "label4", "label4", "label4", "label4", "label4", "label4"] // [String]()

	@IBOutlet weak var homeLabel: UILabel!
	@IBOutlet weak var lectureCollection: UICollectionView!
	
	/*               */
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		//print(profileModel?.email)
		//print(profileModel?.name)
		//print(profileModel?.isHost)
		
		//profileModel = Profile(isHost: <#T##Bool#>, name: <#T##String#>, email: <#T##String#>)
		
		//print(tuplePassed)
		
		let user = Auth.auth().currentUser
		if let user = user {
			//print(user.email)
			db.collection("Users").document(user.email!).getDocument(completion: { (document, error) in
				if let document = document, document.exists {
					let name = document.get("Name") as! String
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
		let alertController = UIAlertController(title: "Connect", message: "Please enter the lecture code:", preferredStyle: .alert)
		alertController.addTextField(configurationHandler: passcodeTextFieldHandler)
		
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(okAction)
		alertController.addAction(cancelAction)
		
		self.present(alertController, animated: true)
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

}
