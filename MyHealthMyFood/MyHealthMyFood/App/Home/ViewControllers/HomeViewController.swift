import Foundation
import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeManagerDelegate {
   
    // MARK: - Properties
    var results = [TestRecipe]()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigation()
        setupTableView()
        setupHomeManager()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    // MARK: - Private Methods
    private func setupNavigation() {
        navigationItem.title = "My Health My Food 🍓"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupHomeManager() {
        HomeManager.shared.delegate = self
        HomeManager.shared.fetchTestRecipe(with: API.URL.test)
    }
    
    // MARK: - Table View DataSource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = results[indexPath.row].title
        cell.recipeImageView.load(url: results[indexPath.row].image)
        return cell
    }
    
    // MARK: - HomeManagerDelegate -
    func update(with results: [TestRecipe]?) {
        guard let results = results else { return }
        self.results = results
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
