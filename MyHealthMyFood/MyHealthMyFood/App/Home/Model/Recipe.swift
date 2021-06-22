import Foundation

struct Recipe: Codable {
    var id: Int
    var title: String
    var image: String
    var nutrition: Nutrients
}
