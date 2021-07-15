import Foundation

struct RecipeDetails: Codable {
    var id: Int
    var localId: String?
    var title: String
    var image: String
    var healthScore: Int
    var aggregateLikes: Int
    var servings: Int
    var summary: String
    var readyInMinutes: Int
    var diets: [String]
    var analyzedInstructions: [AnalyzedInstructions]
}
