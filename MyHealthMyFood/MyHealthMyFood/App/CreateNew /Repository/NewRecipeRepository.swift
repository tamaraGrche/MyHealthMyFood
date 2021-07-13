import Foundation

protocol NewRecipeRepository {
    func loadNewRecipe(recipeID: String) -> NewRecipe?
}
