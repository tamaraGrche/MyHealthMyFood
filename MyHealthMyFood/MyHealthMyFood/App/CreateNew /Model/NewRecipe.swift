import Foundation

struct NewRecipe: Codable {
    var id: String
    var recipe: Recipe
    var recipeDetails: RecipeDetails
}
