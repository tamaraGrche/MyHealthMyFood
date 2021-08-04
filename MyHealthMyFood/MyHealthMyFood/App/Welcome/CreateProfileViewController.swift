import Foundation
import UIKit

class CreateProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "tabBarController") as? UITabBarController {
            self.present(vc, animated: true, completion: nil)
        }
    }
}
