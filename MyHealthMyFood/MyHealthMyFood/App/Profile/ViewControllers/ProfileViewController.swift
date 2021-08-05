import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Public Properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var users: [User]?
    
    // MARK: - IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData() {
        do {
            users = try context.fetch(User.fetchRequest())
            DispatchQueue.main.async {
                if let users = self.users {
                    if !users.isEmpty {
                        self.firstName.text = users.last?.firstName
                        self.lastName.text = users.last?.lastName
                        self.email.text = users.last?.email
                    }
                }
            }
        } catch {
            print("Fetch data")
        }
    }
    
}
