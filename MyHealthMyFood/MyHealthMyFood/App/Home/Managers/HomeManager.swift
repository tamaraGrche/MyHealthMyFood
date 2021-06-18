import Foundation

protocol HomeManagerDelegate {
    func update(with results: [TestRecipe]?)
}

class HomeManager {
    
    static let shared: HomeManager = HomeManager()
    var delegate: HomeManagerDelegate? = nil
    
    func fetchTestRecipe(with url: String) {
        guard let url = URL(string: url) else { return }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let results = try? decoder.decode(TestResults.self, from: data)
            self.delegate?.update(with: results?.results)
        }
        task.resume()
    }
}
