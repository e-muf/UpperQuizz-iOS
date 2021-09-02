//
//  ExamsController.swift
//  UpperQuizz
//
//  Created by Emanuel Flores Martínez on 20/07/21.
//

import UIKit

// MARK: - MainTabController Class
final class EvaluationController: UITableViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Helpers
    func configureViewController() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = Constants.evaluationTitle
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
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EvaluationCell.reuseId, for: indexPath) as! EvaluationCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Present questions for specific evaluation
        print("DEBUG: Implement functionality here")
    }
}