import Foundation

struct API {
    
    struct URL {
        static let test = "https://api.spoonacular.com/recipes/complexSearch?\(key)"
        static let recipes = "https://api.spoonacular.com/recipes/complexSearch?sort=calories&sortDirection=asc&minFat=20&minProtein=10&maxProtein=100&number=30&\(key)"
    }
    
    static let key = "apiKey=1de5147fedbd4f7cb35a81418d400f97"
}
