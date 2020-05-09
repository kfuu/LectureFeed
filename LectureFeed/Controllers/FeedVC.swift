//
//  FeedVC.swift
//  LectureFeed
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
	var listener: ListenerRegistration? = nil

	@IBOutlet weak var feedTable: UITableView!
	@IBAction func unwindToFeed(_ sender: UIStoryboardSegue) {
		print("HELLO IM BACK")
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		// Do any additional setup after loading the view.

		navigationItem.title = "Lecture ID: " + (lectureID ?? "00000")
		
		listener = db.collection("Lectures").document(fullLectureID!).addSnapshotListener { documentSnapshot, error in
			guard let document = documentSnapshot else {
				print("Error fetching document: \(error)")
				return
			}
			guard document.data() != nil else {
				print("Document data was empty")
				return
			}
			
			self.loadTable()
			
		}
        
    }
	
	func loadTable() {
		let docRef = db.collection("Lectures").document(fullLectureID!)
		
		docRef.getDocument { (document, error) in
			if let document = document, document.exists {
				let docDate = document.get("date") as! Timestamp
				//let questionArray = document.get("questionList") as! NSArray
				let questionMap = document.get("questionMap") as! NSDictionary

				arr.shared.questionsArr = []
				
				for (questionNum, questionObj) in questionMap {
					let question = questionObj as! NSDictionary
					
					let bodyText = question.value(forKey: "bodyText") as! String
					let sender = question.value(forKey: "sender") as! String
					let date = question.value(forKey: "date") as! Timestamp
					let numLikes = question.value(forKey: "numLikes") as! Int
					let dateNS = date.dateValue()
					
					let q = Question(sender: sender, bodyText: bodyText, date: dateNS as Date, numLikes: numLikes)
					arr.shared.questionsArr.insert(q, at: 0)
				}

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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let vc = segue.destination as? QuestionVC
		vc?.lectureID = self.fullLectureID
		vc?.profileModel = self.profileModel
	}

}
