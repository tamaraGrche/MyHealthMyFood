import Foundation

class HomeDetailsMenager {
    
    static let shared: HomeDetailsMenager = HomeDetailsMenager()
    
    func fetchDetailsRecipe(for url: String, success: @escaping (RecipeDetails?) -> (), failure: @escaping (String) -> ()) {
        guard let url = URL(string: url) else { return }
        let urlReguest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlReguest) { data, urlReguest, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    failure("Loading data error")
                }
                return
            }
            let decoder = JSONDecoder()
            let results = try? decoder.decode(RecipeDetails.self, from: data)
            DispatchQueue.main.async {
                success(results)
            }
        }
        task.resume()
    }
    
}
