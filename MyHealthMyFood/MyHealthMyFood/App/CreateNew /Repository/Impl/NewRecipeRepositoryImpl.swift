import Foundation

class NewRecipeRepositoryImpl: NewRecipeRepository {
    
    // MARK: - Public Properties
    let defaults = UserDefaults.standard
    
    // MARK: - Methodes
    func loadNewRecipe(recipeID: String) -> NewRecipe? {
        if let savedRecipe = defaults.object(forKey: recipeID) as? Data {
            let decoder = JSONDecoder()
            if let loadedRecipe = try? decoder.decode(NewRecipe.self, from: savedRecipe) {
                return loadedRecipe
            }
        }
        return nil
    }
}
