import Foundation
import UIKit

class CreateNewViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var recipeImageButton: UIButton!
    @IBOutlet weak var recipeTitleTextField: UITextField!
    @IBOutlet weak var healthScoreTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var servingPeopleTextField: UITextField!
    @IBOutlet weak var dietsTextField: UITextField!
    
   
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: IBAction
    @IBAction func recipeImageButtonTapped(_ sender: Any) {
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
}
