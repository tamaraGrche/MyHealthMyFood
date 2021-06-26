import Foundation
import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeManagerDelegate {
   
    // MARK: - Properties
    var results = [Recipe]()
    
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
        if results.isEmpty {
            tableView.isHidden = true
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupHomeManager() {
        HomeManager.shared.delegate = self
        HomeManager.shared.fetchTestRecipe(with: API.URL.recipes)
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
        let calories = results[indexPath.row].nutrition.nutrients[2].amount
        let caloriesUnit = results[indexPath.row].nutrition.nutrients[2].unit
        let fat = results[indexPath.row].nutrition.nutrients[1].amount
        let fatUnit = results[indexPath.row].nutrition.nutrients[1].unit
        let protein = results[indexPath.row].nutrition.nutrients[0].amount
        let proteinUnit = results[indexPath.row].nutrition.nutrients[0].unit
        cell.proteinLabel.text = String(format: "%.1f", protein) + " " + proteinUnit
        cell.caloriesLabel.text = String(format: "%.1f", calories) + " " + caloriesUnit
        cell.fatLabel.text = String(format: "%.1f", fat) + " " + fatUnit
        
        return cell
    }
    
    // MARK: - Table View Delegate -
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as? HomeDetailViewController else { return }
   
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - HomeManagerDelegate -
    func update(with results: [Recipe]?) {
        guard let results = results else { return }
        self.results = results
        DispatchQueue.main.async {
            if results.isEmpty {
                self.tableView.isHidden = true
            } else {
                self.tableView.isHidden = false
            }
            self.tableView.reloadData()
        }
    }
    
}
