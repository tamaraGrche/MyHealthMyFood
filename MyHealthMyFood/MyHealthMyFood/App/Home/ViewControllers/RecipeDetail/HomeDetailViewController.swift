import Foundation
import UIKit

class HomeDetailViewController: UIViewController {
    
    // MARK: - Private Properties
    private let repository: NewRecipeRepository = NewRecipeRepositoryImpl()

    // MARK: - Public properties
    var id: Int?
    var localId: String?
    var URL: String?
    var results: RecipeDetails?
    var calories: Double?
    var protein: Double?
    var fat: Double?
    var analyzed:[AnalyzedInstructions]?
    var generatedInstructions = """
        """
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var dietLabel: UILabel!
    @IBOutlet weak var proteinsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var dietImage: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never
        if id == 10000 { // default id, always used for local recipes
            if let localId = localId {
                if let newRecipe = repository.loadNewRecipe(recipeID: localId) {
                    startActivityIndicator()
                    updateView(with: newRecipe.recipeDetails)
                    stopActivityIndicator()
                }
            }
        } else {
            generateURLForRecipeDetails()
            setUpHomeDetailManager()
        }
    }
    
    override func viewDidLoad() {
        setUpLikesButtonUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Private Methods
    private func generateURLForRecipeDetails() {
        guard let id = id  else { return }
        URL = "https://api.spoonacular.com/recipes/\(id)/information?\(API.key)"
    }
    
    private func setUpHomeDetailManager() {
        startActivityIndicator()
        HomeDetailsMenager.shared.fetchDetailsRecipe(for: URL ?? "") { recipeDetails in
            self.stopActivityIndicator()
            guard let recipeDetails = recipeDetails else { return }
            self.updateView(with: recipeDetails)
            self.imageRecipe.load(url: recipeDetails.image)
        } failure: { errorMessage in
            self.stopActivityIndicator()
            let ac = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(ac, animated: true, completion: nil)
        }

    }
    
    private func updateView(with recipeDetails: RecipeDetails) {
        titleLabel.text = recipeDetails.title
        healthLabel.text = "Health score: \(String(describing: recipeDetails.healthScore))"
        timeLabel.text = "Time: \(String(describing: recipeDetails.readyInMinutes)) minutes"
        servingLabel.text = "Serving: \(String(describing: recipeDetails.servings)) people"
        if generateString(for: recipeDetails.diets).isEmpty {
            dietLabel.isHidden = true
            dietImage.isHidden = true
        } else {
            dietLabel.text = "Diets: \(generateString(for: recipeDetails.diets))"
        }
        if let protein = protein, let calories = calories, let fat = fat {
            proteinsLabel.text = String(format: "%.1f", protein)
            caloriesLabel.text = String(format: "%.1f", calories)
            fatLabel.text = String(format: "%.1f", fat)
        }
        summaryLabel.text = "\(recipeDetails.summary)"
        likesButton.setTitle("  Likes: \(recipeDetails.aggregateLikes)", for: .normal)
        
        analyzed = recipeDetails.analyzedInstructions
        if let analyzed = analyzed {
            if !analyzed.isEmpty {
                let steps = recipeDetails.analyzedInstructions[0].steps
                for (index,_) in steps.enumerated() {
                    generatedInstructions += """
                    Step \(analyzed[0].steps[index].number)
                    
                    \(analyzed[0].steps[index].step)
                    
                    
                    """
                }
                stepsLabel.text = generatedInstructions
                
            }
        }
      
        let attributedString = htmlAttributedString()
        summaryLabel.attributedText = attributedString
    }
    
    private func startActivityIndicator() {
        activityIndicatorView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func stopActivityIndicator() {
        activityIndicatorView.isHidden = true
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func setUpLikesButtonUI() {
        likesButton.layer.borderWidth = 1
        likesButton.layer.borderColor = UIColor(named: "brand")?.cgColor
        likesButton.layer.cornerRadius = 20
    }
    
    private func generateString(for diets: [String]) -> String {
        var generatedString = ""
        var count = 1
        for diet in diets {
            if diets.count == count {
                generatedString += diet
            } else {
                generatedString += diet + ", "
                count += 1
            }
        }
        return generatedString
    }
    
    private func htmlAttributedString() -> NSAttributedString {
        guard let summaryLabel = summaryLabel.text else { return NSAttributedString()}
        let htmlTemplate = """
        <!doctype html>
        <html>
          <head>
            <style>
              body {
                font-family: -apple-system;
                font-size: 16px;
              }
            </style>
          </head>
          <body>
            \(summaryLabel)
          </body>
        </html>
        """

        guard let data = htmlTemplate.data(using: .utf8) else {
            return NSAttributedString()
        }

        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
            ) else {
            return NSAttributedString()
        }

        return attributedString
    }
    
    
    // MARK: - IBActions
    @IBAction func likesButtonTapped(_ sender: Any) {
        if let results = results {
            likesButton.setTitle("  Likes: \(results.aggregateLikes + 1)", for: .normal)
        }
    }
}
