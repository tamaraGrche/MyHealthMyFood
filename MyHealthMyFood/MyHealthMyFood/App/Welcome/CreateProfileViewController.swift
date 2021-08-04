import Foundation
import UIKit

class CreateProfileViewController: UIViewController {
    
    // MARK: - Public Properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var users: [User]?
    
    // MARK: - IBOutlets
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
   //     fetchData()
    }
    
    // MARK: - Methodes
    func textFieldsNotEmpty() -> Bool {
        if let name = firstName.text, !name.isEmpty {
            if let surname = lastName.text, !surname.isEmpty {
               return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func saveData() {
        let user = User(context: context)
        user.firstName = firstName.text
        user.lastName = lastName.text
        
        do {
            try context.save()
            if let vc = self.storyboard?.instantiateViewController(identifier: "tabBarController") as? UITabBarController {
                self.present(vc, animated: true, completion: nil)
            }
        } catch {
            let ac = UIAlertController(title: "Can't save data", message: "Something went wrong. Please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
//    func fetchData() {
//        do {
//            users = try context.fetch(User.fetchRequest())
//            DispatchQueue.main.async {
//                if let users = self.users {
//                    if !users.isEmpty {
//                        self.firstName.placeholder = users.last?.firstName
//                        self.lastName.placeholder = users.last?.lastName
//                    }
//                }
//            }
//        } catch {
//          print("FEtch data")
//        }
//    }
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        if textFieldsNotEmpty() {
            saveData()
        } else {
            let ac = UIAlertController(title: "Try again", message: "Some text fields are empty", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(ac, animated: true, completion: nil)
        }
    }

}
