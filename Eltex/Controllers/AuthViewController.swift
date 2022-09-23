//
//  AuthViewController.swift
//  Eltex
//
//  Created by Yersage on 22.09.2022.
//

import UIKit

class AuthViewController: UIViewController {
    // MARK: - UI Subviews
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Your username"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Your password"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    // MARK: - Dependencies
    let manager = AuthManager()
    var tokenModel: TokenModel?
    
    // MARK: - UIViewController lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign In"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        button.addTarget(self,
                         action: #selector(signInButtonPressed),
                         for: .touchUpInside)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(button)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        usernameTextField.frame = CGRect(x: 30,
                                         y: 30,
                                      width: scrollView.width - 60,
                                      height: 52)
        
        passwordTextField.frame = CGRect(x: 30,
                                         y: usernameTextField.bottom + 10,
                                         width: scrollView.width - 60,
                                         height: 52)
        
        button.frame = CGRect(x: 30,
                              y: passwordTextField.bottom  + 10,
                              width: scrollView.width - 60,
                              height: 52)
    }
    
    // MARK: - Selector methods
    @objc func signInButtonPressed() {
        manager.load { [weak self] result in
            switch result {
            case .success(let model):
                print(model)
                self?.tokenModel = model
                DispatchQueue.main.async {
                    let vc = ProfileViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            signInButtonPressed()
        }
        
        return true
    }
}
