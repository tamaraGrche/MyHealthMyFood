import Foundation

protocol HomeDetailProtocol {
    func update(with results: RecipeDetails?)
}

class HomeDetailsMenager {
    
    static let shared: HomeDetailsMenager = HomeDetailsMenager()
    var delegate: HomeDetailProtocol? = nil
    
    func fetchDetailsRecipe(for url: String) {
        guard let url = URL(string: url) else { return }
        let urlReguest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlReguest) { data, urlReguest, error in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let results = try? decoder.decode(RecipeDetails.self, from: data)
            self.delegate?.update(with: results)
        }
        task.resume()
    }
    
}
