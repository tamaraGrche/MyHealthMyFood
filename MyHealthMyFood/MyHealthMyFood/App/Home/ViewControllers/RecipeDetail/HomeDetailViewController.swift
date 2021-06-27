import Foundation
import UIKit

class HomeDetailViewController: UIViewController, HomeDetailProtocol {
    
    
    // MARK: - Public properties
    var id: Int?
    var URL: String?
    var results: RecipeDetails?
    var calories: Double?
    var protein: Double?
    var fat: Double?
    
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
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        navigationItem.largeTitleDisplayMode = .never
        generateURLForRecipeDetails()
        HomeDetailsMenager.shared.delegate = self
        HomeDetailsMenager.shared.fetchDetailsRecipe(for: URL ?? "")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Private Methods
    private func generateURLForRecipeDetails() {
        guard let id = id  else { return }
        URL = "https://api.spoonacular.com/recipes/\(id)/information?\(API.key)"
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
    
    // MARK: - Public Methods
    func update(with results: RecipeDetails?) {
        self.results = results
        if let results = results {
            DispatchQueue.main.async {
                self.titleLabel.text = results.title
                self.healthLabel.text = "Health score: \(String(describing: results.healthScore))"
                self.timeLabel.text = "Time: \(String(describing: results.readyInMinutes)) minutes"
                self.servingLabel.text = "Serving: \(String(describing: results.servings)) people"
                self.dietLabel.text = "Diets: \(self.generateString(for: results.diets))"
                if let protein = self.protein, let calories = self.calories, let fat = self.fat {
                    self.proteinsLabel.text = String(format: "%.1f", protein)
                    self.caloriesLabel.text = String(format: "%.1f", calories)
                    self.fatLabel.text = String(format: "%.1f", fat)
                }
                self.summaryLabel.text = "\(String(describing: results.summary))"
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func likesButtonTapped(_ sender: Any) {
    }
    
}
