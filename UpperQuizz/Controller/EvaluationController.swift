//
//  ExamsController.swift
//  UpperQuizz
//
//  Created by Emanuel Flores Martínez on 20/07/21.
//

import UIKit

// MARK: - MainTabController Class
final class EvaluationController: UITableViewController {
    // MARK: - Properties
    var evaluations: [Evaluation]? = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        fetchEvaluations()
        //evaluations = LocalDataManager.getData(of: [Evaluation].self, from: "evaluaciones")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Network
    private func fetchEvaluations() {
        EvaluationService.shared.getEvaluations { result in
            switch result {
            case .success(let evaluations):
                self.evaluations = evaluations
                self.tableView.reloadData()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Actions
    @objc func handleLogout() {
        AuthenticationService.shared.logUserOut(viewController: self)
    }
    
    // MARK: - Helpers
    func configureViewController() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = Constants.evaluationTitle
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    func configureTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constants.backgroundColor
        self.tableView.register(EvaluationCell.self, forCellReuseIdentifier: EvaluationCell.reuseId)
    }
}

// MARK: - UICollectionViewDataSource
extension EvaluationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evaluations?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EvaluationCell.reuseId, for: indexPath) as! EvaluationCell
        guard let currentEvaluation = evaluations?[indexPath.row] else { return UITableViewCell() }
        cell.viewModel = EvaluationViewModel(evaluation: currentEvaluation)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Present questions for specific evaluation
        print("DEBUG: Implement functionality here")
    }
}
