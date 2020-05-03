//
//  SignUpSignInVC.swift
//  LectureFeed
//
//  Created by Silin Chen on 5/1/20.
//  Copyright © 2020 Silin Chen. All rights reserved.
//

import UIKit
import Firebase

class SignUpSignInVC: UIViewController {
	
	var signInSelected: Bool = false

	@IBOutlet weak var confirmButton: UIButton!
	@IBOutlet weak var authToggle: UISegmentedControl!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var nameTextField: UITextField!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		//print(authToggle.selectedSegmentIndex)
    }
    
	@IBAction func toggleChange(_ sender: Any) {
		signInSelected = !signInSelected // if tapped on Sign Up, it becomes Sign In now
		
		if signInSelected {
			nameTextField.isHidden = true
			confirmButton.titleLabel?.text = "Sign In"
		}
		else {
			nameTextField.isHidden = false
			confirmButton.titleLabel?.text = "Sign Up"
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
	
	func handleSignIn() {
		guard let email = emailTextField.text, let password = passwordTextField.text else {
			print("Must enter email and password")
			return
		}
		
		Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
			print(user)
			print(error)
			
			if error != nil {
				print(error ?? "")
				return
			}
			
			if user != nil {
				// segue to new VC with data
				print("good!")
			}
			else { // invalid credentials
				let alert = UIAlertController(title: "Invalid Input", message: "Email and password do not match account credentials. Please try again, or make a new account if you don't already have one.", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
				self.present(alert, animated: true)
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
			if error != nil {
				print(error ?? "")
				return
			}
			
			// let newProfile = Profile()
			
			if user != nil && !name.isEmpty {
				// segue
				
				// add account to database
			}
			else { // error adding account to db
				
			}
		})
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
