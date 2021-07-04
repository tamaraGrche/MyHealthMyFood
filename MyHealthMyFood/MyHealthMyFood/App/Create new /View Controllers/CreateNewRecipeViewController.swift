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
    @IBOutlet weak var proteinsTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupTextFieldsPlaceholder()
    }
    
    // MARK: - Private Methods
    private func setupTextFieldsPlaceholder() {
        proteinsTextField.attributedPlaceholder = NSAttributedString(string: "18 g",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        caloriesTextField.attributedPlaceholder = NSAttributedString(string: "135 cal",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        fatTextField.attributedPlaceholder = NSAttributedString(string: "56 g",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
    }
    
    private func checkTextFields() {
        guard let recipeTitle = recipeTitleTextField.text, !recipeTitle.isEmpty  else {
           showAlert(title: "Missing field", message: "Recipe title is mendatory. Please insert title.")
            return
        }
        
        guard let healthScore = healthScoreTextField.text, !healthScore.isEmpty else {
            showAlert(title: "Missing field", message: "Health score number is mendatory. Please insers number.")
            return
        }
        
        guard let time = timeTextField.text, !time.isEmpty else {
            showAlert(title: "Missing field", message: "Recipe time for preparation is mendatory. Please insert your time.")
            return
        }
        
        guard let servingPeople = servingPeopleTextField.text, !servingPeople.isEmpty else {
            showAlert(title: "Missing field", message: "Number of people for serving is mendatory. Please insert number of people.")
            return
        }
        
        guard let diets = dietsTextField.text, !diets.isEmpty else {
            showAlert(title: "Missing field", message: "Diets for your recipe is mendatory. Please insert diets.")
            return
        }
        
        guard let proteins = proteinsTextField.text, !proteins.isEmpty else {
            showAlert(title: "Missing field", message: "Number of proteins are mendatory. Please insers number.")
            return
        }
        
        guard let calories = caloriesTextField.text, !calories.isEmpty else {
            showAlert(title: "Missing field", message: "Number of calories are mendatory. Please insers number.")
            return
        }
        
        guard let fat = fatTextField.text, !fat.isEmpty else {
            showAlert(title: "Missing field", message: "Fat number is mendatory. Please insers number.")
            return
        }
    
    }
    
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    // MARK: - IBAction
    @IBAction func recipeImageButtonTapped(_ sender: Any) {
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        checkTextFields()
    }
}
