import Foundation

struct RecipeDetails: Codable {
    var vegan: Bool
    var healthScore: Int
    var aggregateLikes: Int
    var servings: Int
    var summary: String
    var readyInMinutes: Int
    var diets: [String]
    var analyzedInstructions: [AnalyzedInstructions]
}
