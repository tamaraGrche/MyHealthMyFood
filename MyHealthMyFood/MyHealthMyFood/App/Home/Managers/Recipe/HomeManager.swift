import Foundation

class HomeManager {
    
    static let shared: HomeManager = HomeManager()
    
    func fetchRecipe(with url: String, success: @escaping ([Recipe]?) -> (), failure: @escaping (String) -> ()) {
        guard let url = URL(string: url) else {
            failure("Wrong URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    failure("Loading data error")
                }
                return
            }
            let decoder = JSONDecoder()
            let results = try? decoder.decode(RecipeResults.self, from: data)
            DispatchQueue.main.async {
                success(results?.results)
            }
        }
        task.resume()
    }
}
