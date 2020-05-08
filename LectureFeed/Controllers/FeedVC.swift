//
//  FeedVC.swift
//  LectureFeed
//
//  Created by Silin Chen on 5/8/20.
//  Copyright © 2020 Silin Chen. All rights reserved.
//

import UIKit
import Firebase

public class arr {
	var questionsArr: [Question] = []
	public static let shared = arr()
}

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var profileModel: Profile?
	var lectureID: String?
	var fullLectureID: String?
	//var questionList: [Question] = []

	@IBOutlet weak var feedTable: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		navigationItem.title = "Lecture ID: " + (lectureID ?? "00000")
		
		loadTable()

        // Do any additional setup after loading the view.
    }
	
	func loadTable() {
		let docRef = db.collection("Lectures").document(fullLectureID!)
		
		docRef.getDocument { (document, error) in
			if let document = document, document.exists {
				let docDate = document.get("date") as! Timestamp
				let questionArray = document.get("questionList") as! NSArray

				arr.shared.questionsArr = []
				
				for question in questionArray {
					let qM = question as! NSDictionary
					let bodyText = qM.value(forKey: "bodyText") as! String
					let sender = qM.value(forKey: "sender") as! String
					let numLikes = qM.value(forKey: "numLikes") as! Int
					let date = qM.value(forKey: "date") as! Timestamp
					let dateNS = date.dateValue()
					
					let questionObject = Question(sender: sender, bodyText: bodyText, date: dateNS as Date, numLikes: numLikes)
					arr.shared.questionsArr.append(questionObject)
				} // end for loop
			} // end document exists
			else {
				print("Document does not exist.")
			}
			
			self.feedTable.reloadData()
		} // end getDocument
		
		feedTable.dataSource = self
	} // end loadTable()
	
	@IBAction func newQuestion(_ sender: Any) {
		self.performSegue(withIdentifier: "writeQuestion", sender: self)
	}
	
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arr.shared.questionsArr.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = feedTable.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionCell
		//cell?.textLabel?.text = arr.shared.questionsArr[indexPath.row].bodyText
		let sender = arr.shared.questionsArr[indexPath.row].sender
		let date = arr.shared.questionsArr[indexPath.row].date
		let bodyText = arr.shared.questionsArr[indexPath.row].bodyText
		
		cell.setCell(sender: sender!, date: date!, bodyText: bodyText!)
		return cell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		let vc = segue.destination as? QuestionVC
//
//	}

}
