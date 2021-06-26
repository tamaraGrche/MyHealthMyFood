import Foundation
import UIKit

class HomeDetailViewController: UIViewController, HomeDetailProtocol {
    
    
    // MARK: - Public properties
    var id: Int?
    var URL: String?
    var results: RecipeDetails?
    
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
    
    // MARK: Private Methodes
    func generateURLForRecipeDetails () {
        guard let id = id  else { return }
        URL = "https://api.spoonacular.com/recipes/\(id)/information?\(API.key)"
    }
    
    func update(with results: RecipeDetails?) {
        self.results = results
        print(results)
    }
    
}
