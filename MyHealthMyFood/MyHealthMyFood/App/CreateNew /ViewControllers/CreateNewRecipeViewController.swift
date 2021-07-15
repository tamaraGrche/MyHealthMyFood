import Foundation
import UIKit

class CreateNewViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Private Properties
    private var recipeImage = UIImage()
    private let defaults = UserDefaults.standard
    
    // MARK: - IBOutlets
    @IBOutlet weak var recipeImageButton: UIButton!
    @IBOutlet weak var recipeTitleTextField: UITextField!
    @IBOutlet weak var healthScoreTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var servingPeopleTextField: UITextField!
    @IBOutlet weak var dietsTextField: UITextField!
    @IBOutlet weak var proteinsTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var instructionsTextView: UITextView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupTextFieldsPlaceholder()
        summaryTextView.delegate = self
        instructionsTextView.delegate = self
        setupSummaryTextViewPlaceholder()
        setupInstructionsTextViewPlaceholder()
        recipeImageButton.imageView?.layer.cornerRadius = 20
        recipeImageButton.imageView?.contentMode = .scaleAspectFill
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
    
    private func setupSummaryTextViewPlaceholder() {
        summaryTextView.text = "Write recipe summary ..."
        summaryTextView.textColor = .black.withAlphaComponent(0.6)
    }
    
    private func setupInstructionsTextViewPlaceholder() {
        instructionsTextView.text = "Write instructions for your recipe ..."
        instructionsTextView.textColor = .black.withAlphaComponent(0.6)
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

        guard let summary = summaryTextView.text, !summary.isEmpty else {
            showAlert(title: "Missing field", message: "Summary text is mendatory. Please insers recipe summary.")
            return
        }
        
        let dietsArray = diets.components(separatedBy: ", ")
        let nutrients = [
            Nutrient(title: "protein", name: "protein", amount: Double(proteins) ?? 0.0, unit: "g"),
            Nutrient(title: "fat", name: "fat", amount: Double(fat) ?? 0.0, unit: "g"),
            Nutrient(title: "calories", name: "calories", amount: Double(calories) ?? 0.0, unit: "cal")
        ]
        
        let id = UUID().uuidString
        let defaultId = 10000
        
        let recipe = Recipe(id: defaultId, localId: id, title: recipeTitle, image: "", nutrition: Nutrients(nutrients: nutrients))
        let recipeDetails = RecipeDetails(id: defaultId, localId: id, title: recipeTitle, image: "", healthScore: Int(healthScore) ?? 0, aggregateLikes: 0, servings: Int(servingPeople) ?? 0, summary: summary, readyInMinutes: Int(time) ?? 0, diets: dietsArray, analyzedInstructions: [])
        
        let newRecipe = NewRecipe(id: id, recipe: recipe, recipeDetails: recipeDetails)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(newRecipe) {
            defaults.set(encoded, forKey: id)
            if var localSavedRecipe = defaults.object(forKey: "localSave") as? [String] {
                localSavedRecipe.append(id)
                defaults.set(localSavedRecipe,forKey: "localSave")
            } else {
                var localIDs = [String]()
                localIDs.append(id)
                defaults.set(localIDs, forKey: "localSave")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    // MARK: - IBAction -
    @IBAction func recipeImageButtonTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Choose image from:", message: "", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            self.present(vc, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.allowsEditing = true
            vc.delegate = self
            self.present(vc, animated: true)
        })
        present(ac, animated: true, completion: nil)
      
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        checkTextFields()
    }
    
    // MARK: - TextViewDelegate Methodes -
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .black.withAlphaComponent(0.6) {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.hasText {
            if textView == summaryTextView {
                setupSummaryTextViewPlaceholder()
            }
            if textView == instructionsTextView {
                setupInstructionsTextViewPlaceholder()
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate -
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        recipeImage = image
        recipeImageButton.setImage(image, for: .normal)
    }
}
