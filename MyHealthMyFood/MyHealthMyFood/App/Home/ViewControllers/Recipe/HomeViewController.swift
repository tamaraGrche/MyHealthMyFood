import Foundation
import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    // MARK: - Private Properties
    private let repository: NewRecipeRepository = NewRecipeRepositoryImpl()
    
    // MARK: - Public Properties
    var recipes = [Recipe]()
    let defaults = UserDefaults.standard
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupTableView()
        setupHomeManager()
    }
    
    // MARK: - Private Methods
    private func setupNavigation() {
        navigationItem.title = "My Health My Food 🍓"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        if recipes.isEmpty {
            tableView.isHidden = true
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func startActivityIndicator() {
        self.activityIndicatorView.isHidden = false
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    private func stopActivityIndicator() {
        self.activityIndicatorView.isHidden = true
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    private func setupHomeManager() {
        startActivityIndicator()
        HomeManager.shared.fetchRecipe(with: API.URL.recipes) { recipes in
            self.stopActivityIndicator()
            self.update(with: recipes)
            self.loadSavedRecipes()
        } failure: { errorMessage in
            self.stopActivityIndicator()
            self.loadSavedRecipes()
            let ac = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    private func loadSavedRecipes() {
        if let localSavedRecipe = defaults.object(forKey: "localSave") as? [String] {
            for id in localSavedRecipe {
                let newRecipe = repository.loadNewRecipe(recipeID: id)
                if let newRecipe = newRecipe {
                    self.recipes.append(newRecipe.recipe)
                }
            }
            updateTableView()
        }
    }
    
    private func updateTableView() {
        if self.recipes.isEmpty {
            self.tableView.isHidden = true
        } else {
            self.tableView.isHidden = false
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table View DataSource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = recipes[indexPath.row].title
        cell.recipeImageView.load(url: recipes[indexPath.row].image)
        let calories = recipes[indexPath.row].nutrition.nutrients[2].amount
        let caloriesUnit = recipes[indexPath.row].nutrition.nutrients[2].unit
        let fat = recipes[indexPath.row].nutrition.nutrients[1].amount
        let fatUnit = recipes[indexPath.row].nutrition.nutrients[1].unit
        let protein = recipes[indexPath.row].nutrition.nutrients[0].amount
        let proteinUnit = recipes[indexPath.row].nutrition.nutrients[0].unit
        cell.proteinLabel.text = String(format: "%.1f", protein) + " " + proteinUnit
        cell.caloriesLabel.text = String(format: "%.1f", calories) + " " + caloriesUnit
        cell.fatLabel.text = String(format: "%.1f", fat) + " " + fatUnit
        
        return cell
    }
    
    // MARK: - Table View Delegate -
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as? HomeDetailViewController else { return }
        vc.title = recipes[indexPath.row].title
        vc.id = recipes[indexPath.row].id
        if recipes[indexPath.row].id == 10000 {
            vc.localId = recipes[indexPath.row].localId
        }
        vc.calories = recipes[indexPath.row].nutrition.nutrients[2].amount
        vc.fat = recipes[indexPath.row].nutrition.nutrients[1].amount
        vc.protein = recipes[indexPath.row].nutrition.nutrients[0].amount
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - HomeManager -
    func update(with results: [Recipe]?) {
        guard let results = results else { return }
        self.recipes = results
        updateTableView()
    }
}
