//
//  LoginViewController.swift
//  course4
//
//  Created by Nikolai Prokofev on 2019-02-14.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import UIKit
import Kingfisher

class LoginViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        loadLogo()
    }
    
    private func loadLogo(){
        let logoURL = URL(string: "https://image.flaticon.com/icons/png/512/25/25231.png")
        logoImageView.kf.indicatorType = .activity
        logoImageView.kf.setImage(with: logoURL)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}
