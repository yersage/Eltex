//
//  ViewController.swift
//  Eltex
//
//  Created by Yersage on 22.09.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let roleIDLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private let permissionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Permissions"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 12
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let manager = ProfileManager()
    private var profileModel: ProfileModel?
    var token: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "signed_in") != true {
            return
        }
        
        view.backgroundColor = .white
        
        title = "Profile info"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setHidesBackButton(true,
                                          animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(signOutButtonPressed))
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            fatalError("Token is nil.")
        }
        
        manager.load(token: token) { [weak self] result in
            switch result {
            case .success(let model):
                self?.profileModel = model
                DispatchQueue.main.async {
                    self?.roleIDLabel.text = model.roleId
                    self?.usernameLabel.text = model.username
                    self?.emailLabel.text = model.email
                    self?.tableView.reloadData()
                }                
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(roleIDLabel)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(permissionsLabel)
        scrollView.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        usernameLabel.frame = CGRect(x: 30,
                                     y: 0,
                                     width: scrollView.width - 60,
                                     height: 24)
        roleIDLabel.frame = CGRect(x: 30,
                                   y: usernameLabel.bottom + 6,
                                   width: scrollView.width - 60,
                                   height: 24)
        emailLabel.frame = CGRect(x: 30,
                                  y: roleIDLabel.bottom + 6,
                                  width: scrollView.width - 60,
                                  height: 24)
        permissionsLabel.frame = CGRect(x: 30,
                                        y: emailLabel.bottom + 6,
                                        width: scrollView.width - 60,
                                        height: 24)
        tableView.frame = CGRect(x: 30,
                                 y: permissionsLabel.bottom + 6,
                                 width: scrollView.width - 60,
                                 height: scrollView.height - emailLabel.bottom - 275)
    }
    
    @objc func signOutButtonPressed() {
        UserDefaults.standard.set(false, forKey: "signed_in")
        UserDefaults.standard.removeObject(forKey: "token")
        validateAuth()
    }
    
    private func validateAuth() {
        if UserDefaults.standard.bool(forKey: "signed_in") != true {
            let vc = AuthViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileModel?.permissions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = profileModel?.permissions[indexPath.row]
        return cell
    }
}

