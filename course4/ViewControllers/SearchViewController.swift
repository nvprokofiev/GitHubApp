//
//  SearchViewController.swift
//  course4
//
//  Created by Nikolai Prokofev on 2019-02-26.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController {
    
    private var avatarImageView: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "avatarPlaceholder")
        return view
    }()
    
    private var usernameLabel: UILabel = {
        var label = UILabel()
        label.sizeToFit()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var searchLabel: UILabel = {
        var label = UILabel()
        label.text = "Search repository"
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var repositoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "repository name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private var languageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "language"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private var orderSegment: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.insertSegment(withTitle: "ascended", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "descended", at: 1, animated: false)
        segmentControl.tintColor = UIColor.gray
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    private var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start search", for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Start search", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .medium)]), for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(serachButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private var user: User
    
    init(_ user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.masksToBounds = true
    }
    
    private func setupViews() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = .white
        
        usernameLabel.text = "Hello \(user.login)"
        guard let url = URL(string: user.avatarUrl) else { return }
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(with: url)
    }
    
    private func addSubviews() {
        self.view.addSubview(avatarImageView)
        self.view.addSubview(usernameLabel)
        self.view.addSubview(searchLabel)
        self.view.addSubview(repositoryNameTextField)
        self.view.addSubview(languageTextField)
        self.view.addSubview(orderSegment)
        self.view.addSubview(searchButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            avatarImageView.centerXAnchor.constraint(equalTo: usernameLabel.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 30),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),
            
            searchLabel.centerXAnchor.constraint(equalTo: usernameLabel.centerXAnchor),
            searchLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 50),
            
            repositoryNameTextField.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 26),
            repositoryNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            repositoryNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),

            languageTextField.topAnchor.constraint(equalTo: repositoryNameTextField.bottomAnchor, constant: 12),
            languageTextField.leadingAnchor.constraint(equalTo: repositoryNameTextField.leadingAnchor),
            languageTextField.trailingAnchor.constraint(equalTo: repositoryNameTextField.trailingAnchor),
            
            orderSegment.topAnchor.constraint(equalTo: languageTextField.bottomAnchor, constant: 18),
            orderSegment.leadingAnchor.constraint(equalTo: repositoryNameTextField.leadingAnchor),
            orderSegment.trailingAnchor.constraint(equalTo: repositoryNameTextField.trailingAnchor),
            
            searchButton.topAnchor.constraint(equalTo: orderSegment.bottomAnchor, constant: 36),
            searchButton.centerXAnchor.constraint(equalTo: usernameLabel.centerXAnchor),
            ])
        self.view.layoutIfNeeded()
    }
    
    @objc private func serachButtonTapped() {
        
        self.view.addSubview(activityIndicator)
        
        let order: APIClient.ListOrder = orderSegment.selectedSegmentIndex == 0 ? .acs : .desc
        
        NetworkManager.shared.searchForRepositories(.search(repository: repositoryNameTextField.text ?? "",
                                                                language: languageTextField.text ?? "",
                                                                order: order))
        { [unowned self] result in
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let repositories):
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: RepositoriesViewController.self)) as! RepositoriesViewController
                    vc.repositories = repositories.map{ $0 }
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case .failture(let error):
                    self.presentAlert(with: "Fetching Error", message: error.description)
                }
            }
        }
    }
}
