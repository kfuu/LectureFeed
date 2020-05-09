//
//  HomeVC.swift
//  LectureFeed
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

public class lectureArr {
	var lectureIDArr: [String] = []
	public static let shared = lectureArr()
}

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var profileModel: Profile?
	var tuplePassed: (String, String)?
	var passcodeTextField: UITextField?
	var lectureIDtoPass: String?
	var fulllectureIDtoPass: String?
	
	let labels = [String]() //["label1", "label2", "label3", "label4", "label4", "label4", "label4", "label4", "label4", "label4", "label4", "label4", "label4", "label4"]

	@IBOutlet weak var homeLabel: UILabel!
	@IBOutlet weak var lectureCollection: UICollectionView!
	
	/*               */
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.isModalInPresentation = true
		
        // Do any additional setup after loading the view.
		//profileModel = Profile(isHost: false, name: tuplePassed!.0, email: tuplePassed!.1) // initialization
		
		getUserProfile()
		//loadCollectionView()

		lectureCollection.dataSource = self
		lectureCollection.delegate = self
    }
	
	override func viewDidAppear(_ animated: Bool) {
		self.loadCollectionView()
	}
	
	
	func getUserProfile() {
		let user = Auth.auth().currentUser
		if let user = user {
			//print(user.email)
			db.collection("Users").document(user.email!).getDocument(completion: { (document, error) in
				if let document = document, document.exists {
					let name = document.get("Name") as! String
					let isLecturer = document.get("isLecturer") as! Bool
					let email = document.get("Email") as! String
					self.profileModel = Profile(isHost: isLecturer, name: name, email: email)
					
					let idMap = document.get("IDMap") as! NSDictionary
					for (id, b) in idMap {
						lectureArr.shared.lectureIDArr.append(id as! String)
					}
					
					self.homeLabel.text = "Welcome, " + name
				}
				else {
					print("Document does not exist")
				}
				
				self.loadCollectionView()
			})
		}
	}
	
	func loadCollectionView() {
		self.lectureCollection.reloadData()
	}

	@IBAction func connectToLecture(_ sender: Any) {
		if self.profileModel!.isHost {
			var ref: DocumentReference? = nil
			ref = db.collection("Lectures").addDocument(data: [
				"count" : 0,
				"date" : Timestamp(date: Date()),
				"questionMap" : [:],
				"lectureStartedBy" : self.profileModel?.name
			]) {
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
			self.fulllectureIDtoPass = lectureID
			
			//print("A")
			// add lectures attended to IDMap in Users collection
			let docRef = db.collection("Users").document(self.profileModel!.email)
			docRef.getDocument { (document, error) in
				if let document = document, document.exists {
					//let docCount = document.get("count") as! Int
					docRef.setData([
						"IDMap" : [lectureID : true]
					], merge: true)
					//docRef.setData(["count": docCount+1], merge: true)
				}
			}
			//print("B")
			
			//self.loadCollectionView()
//
			let alertController = UIAlertController(title: "Lecture ID: \(new_lectureID)", message: "Please distribute this lecture ID code to the lecturees. Don't press OK until you are ready to proceed.", preferredStyle: .alert)
			let okAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
				print("cool")

				self.performSegue(withIdentifier: "toLecture", sender: self)
			})
			//let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
			alertController.addAction(okAction)
			//alertController.addAction(cancelAction)
			
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
								self.lectureIDtoPass = String((document.documentID).prefix(5))
								self.fulllectureIDtoPass = String(document.documentID)
								
								//print("J")
								// add lectures attended to IDMap in Users collection
								let docRef = db.collection("Users").document(self.profileModel!.email)
								docRef.getDocument { (document, error) in
									if let document = document, document.exists {
										//let docCount = document.get("count") as! Int
										docRef.setData([
											"IDMap" : [self.fulllectureIDtoPass : true]
										], merge: true)
										//docRef.setData(["count": docCount+1], merge: true)
									}
								}
								//print("K")
								
								//self.loadCollectionView()
								
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
					
				}
			})
			let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
			alertController.addAction(okAction)
			alertController.addAction(cancelAction)
			
			self.present(alertController, animated: true)
		}
	}
	
	@IBAction func signOut(_ sender: Any) {
		//self.performSegue(withIdentifier: "signOut", sender: self)
		let firebaseAuth = Auth.auth()
		do {
			try firebaseAuth.signOut()
			lectureArr.shared.lectureIDArr = []
			self.dismiss(animated: true, completion: {})
		} catch let signOutError as NSError {
			print("Error signing out: \(signOutError)")
		}
	}
	
	func passcodeTextFieldHandler(textField: UITextField!) {
		passcodeTextField = textField
		passcodeTextField?.placeholder = "Passcode"
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return lectureArr.shared.lectureIDArr.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lectureCell", for: indexPath) as! LectureCell
		cell.lectureCellLabel.text = String(lectureArr.shared.lectureIDArr[indexPath.item].prefix(5))
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
		if segue.identifier == "toLecture" {
			// pass the profile object
			
//			let vc = segue.destination as? FeedVC
//			vc?.modalPresentationStyle = .fullScreen // maybe? could be affected by nav vc
//			vc?.profileModel = self.profileModel
//			vc?.lectureID = self.lectureIDtoPass
//			vc?.fullLectureID = self.fulllectureIDtoPass
			
			let destinationNavigationController = segue.destination as! UINavigationController
			let targetController = destinationNavigationController.topViewController as? FeedVC
			
			targetController?.profileModel = self.profileModel
			targetController?.lectureID = self.lectureIDtoPass
			targetController?.fullLectureID = self.fulllectureIDtoPass
			
			targetController?.modalPresentationStyle = .fullScreen
			
		}
	}

}
