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
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    
    func setupViews(){
        loginButton.isEnabled = false
        loadLogo()
    }
    
    private func loadLogo(){
        let logoURL = URL(string: "https://image.flaticon.com/icons/png/512/25/25231.png")
        logoImageView.kf.indicatorType = .activity
        logoImageView.kf.setImage(with: logoURL)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        getUser()
    }
    
    private func getUser(){
        
        guard let username = usernameTextField.text, let password = passwordTextField.text else { return }
        
        NetworkManager.shared.getUser(.authenticate(username: username, password: password)){ [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.navigationController?.pushViewController(SearchViewController(user), animated: true)
                case .failture(let error):
                    self?.presentAlert(with: "Authentication Error", message: error.description)
                }
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        loginButton.isEnabled = passwordTextField.text != "" && usernameTextField.text != ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        return false
    }
}
