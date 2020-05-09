//
//  QuestionVC.swift
//  LectureFeed
//


import UIKit
import Firebase

public class questionTxt {
	var qText: String = ""
	public static let shared = questionTxt()
}

class QuestionVC: UIViewController {
	
	var lectureID: String?
	var profileModel: Profile?

	@IBOutlet weak var questionText: UITextView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	@IBAction func submitAction(_ sender: Any) {
		questionTxt.shared.qText = questionText.text
		let time = Timestamp(date: Date())
		//print(self.questionText.text)
		
		let docRef = db.collection("Lectures").document(self.lectureID!)
		docRef.getDocument { (document, error) in
			if let document = document, document.exists {
				let docCount = document.get("count") as! Int
				docRef.setData([
					"questionMap" : [
						"\(docCount)" : [
							"sender" : self.profileModel?.name,
							"date" : time,
							"bodyText" : questionTxt.shared.qText,
							"numLikes" : 0
						]
					]
				], merge: true)
				docRef.setData(["count": docCount+1], merge: true)
			}
		}
		
		let alert = UIAlertController(title: "", message: "Your question has been successfully posted.", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alert: UIAlertAction!) in
			self.performSegue(withIdentifier: "unwindID", sender: self)
		})
		alert.addAction(okAction)
		self.present(alert, animated: true)
	
		self.questionText.text = ""
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// pass data to unwind
		let destVC = segue.destination as! FeedVC
		destVC.fullLectureID = lectureID
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
