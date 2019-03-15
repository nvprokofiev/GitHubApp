//
//  RepositoriesViewController.swift
//  course4
//
//  Created by Nikolai Prokofev on 2019-03-13.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import UIKit

class RepositoriesViewController: UIViewController {

    @IBOutlet weak var repositoriesFoundLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var repositories: [Repository] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        repositoriesFoundLabel.text = "Repositories found: \(repositories.count)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension RepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepositoryTableViewCell.self), for: indexPath) as! RepositoryTableViewCell
        cell.configureCell(for: repositories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let urlString = repositories[indexPath.row].urlString
        navigationController?.pushViewController(ViewRepositoryViewController(urlString: urlString), animated: true)
    }
}
