import Foundation
import UIKit

class CreateProfileViewController: UIViewController {
    
    // MARK: - Public Properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var users: [User]?
    
    // MARK: - IBOutlets
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
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
        user.email = emailTextField.text
        
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
