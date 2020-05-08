//
//  SignUpSignInVC.swift
//  LectureFeed
//
//  Created by Silin Chen on 5/1/20.
//  Copyright © 2020 Silin Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpSignInVC: UIViewController {
	
	var signInSelected: Bool = false
	//var profileData: Profile?
	var dataTuple: (String, String)?

	@IBOutlet weak var confirmButton: UIButton!
	@IBOutlet weak var authToggle: UISegmentedControl!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var signUpAsLabel: UILabel!
	@IBOutlet weak var signUpAsToggle: UISegmentedControl!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		confirmButton.setTitle("Sign Up", for: .normal) // initial
		
    }
    
	@IBAction func toggleChange(_ sender: Any) {
		signInSelected = !signInSelected // if tapped on Sign Up, it becomes Sign In now
		
		if signInSelected {
			nameTextField.isHidden = true
			signUpAsLabel.isHidden = true
			signUpAsToggle.isHidden = true
			confirmButton.setTitle("Sign In", for: .normal)
		}
		else {
			nameTextField.isHidden = false
			signUpAsLabel.isHidden = false
			signUpAsToggle.isHidden = false
			confirmButton.setTitle("Sign Up", for: .normal)
		}
	}
	
	@IBAction func confirmButtonAction(_ sender: Any) {
		if signInSelected {
			handleSignIn()
		}
		else {
			handleSignUp()
		}
	}
	
//	func checkIfIsLecturer(email: String) -> () {
//		// this is asynchronous
//		db.collection("Users").document(email).getDocument(completion: { (document, error) in
//			if let document = document, document.exists {
//				print("checking...")
//				document.get("isLecturer")
//			}
//			else {
//				print("Document does not exist")
//				}
//		})
//	}
	
	func handleSignIn() {
		guard let email = emailTextField.text, let password = passwordTextField.text else {
			print("Must enter email and password")
			return
		}
		
		Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
			print(user ?? "No user")
			print(error ?? "No error")

			if user != nil {
				// segue to new VC with data
				//self.profileData = Profile(isHost: self.signUpAsToggle.titleForSegment(at: self.signUpAsToggle.selectedSegmentIndex) == "Lecturer", name: "", email: email)
				self.dataTuple = ("", email)
				
				self.performSegue(withIdentifier: "loginToHome", sender: self)

			}
			else { // invalid credentials
				let alert = UIAlertController(title: "Invalid Input", message: "Email and password do not match account credentials. Please try again, or make a new account if you don't already have one.", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
				self.present(alert, animated: true, completion: nil)
				return
			}
		})
	}
	
	func handleSignUp() {
		guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
			print("Must enter name")
			return
		}
		
		Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
			if user != nil && !name.isEmpty {
				// segue
				//self.profileData = Profile(isHost: self.signUpAsToggle.titleForSegment(at: self.signUpAsToggle.selectedSegmentIndex) == "Lecturer", name: name, email: email)
				self.dataTuple = (name, email)
				
				self.performSegue(withIdentifier: "loginToHome", sender: self)
				
//				if self.signUpAsToggle.titleForSegment(at: self.signUpAsToggle.selectedSegmentIndex) == "Lecturer" {
//					print("C")
//					self.performSegue(withIdentifier: "loginToHostHome", sender: self)
//				}
//				else {
//					print("D")
//					self.performSegue(withIdentifier: "loginToHome", sender: self)
//				}
				
				
				// add account to database
				db.collection("Users").document(email).setData([
					"Email": email,
					"Name": name,
					"isLecturer": self.signUpAsToggle.titleForSegment(at: self.signUpAsToggle.selectedSegmentIndex) == "Lecturer"
				]) { err in
					if let err = err {
						print("Error writing document: \(err)")
					} else {
						print("Document successfully written.")
					}
				}
			}
			else { // error adding account to db
				let alert = UIAlertController(title: "Invalid Input", message: "Please make sure you typed your email correctly.", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
				self.present(alert, animated: true)
				return
			}
		})
	}
	
	/*
    // MARK: - Navigation
    */
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is HomeVC {
			let vc = segue.destination as? HomeVC
			vc?.modalPresentationStyle = .fullScreen
			
			vc?.tuplePassed = dataTuple
		}
//		if segue.destination is HomeHostVC {
//			let vc2 = segue.destination as? HomeHostVC
//			vc2?.modalPresentationStyle = .fullScreen
//		}
	}

}
