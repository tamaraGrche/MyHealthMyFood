import Foundation
import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupTableView()
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
    
    // MARK: - Table View DataSource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        cell.recipeImageView.image = UIImage(named: "launchLogo")
        return cell
    }
}
