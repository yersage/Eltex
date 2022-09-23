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
        
        view.backgroundColor = .white
        
        title = "Profile"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setHidesBackButton(true,
                                          animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(signOutButtonPressed))
        
        guard let token = token else {
            fatalError("Token is nil.")
        }
        
        manager.load(token: token) { [weak self] result in
            switch result {
            case .success(let model):
                self?.profileModel = model
                DispatchQueue.main.async {
                    self?.roleIDLabel.text = "roleID: \(model.roleId)"
                    self?.usernameLabel.text = "username: \(model.username)"
                    self?.emailLabel.text = "email: \(model.email ?? "is not provided")"
                    self?.tableView.reloadData()
                }                
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(roleIDLabel)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        roleIDLabel.frame = CGRect(x: 30,
                                   y: 30,
                                   width: scrollView.width - 60,
                                   height: 24)
        usernameLabel.frame = CGRect(x: 30,
                                     y: roleIDLabel.bottom + 6,
                                     width: scrollView.width - 60,
                                     height: 24)
        emailLabel.frame = CGRect(x: 30,
                                  y: usernameLabel.bottom + 6,
                                  width: scrollView.width - 60,
                                  height: 24)
        tableView.frame = CGRect(x: 30,
                                 y: emailLabel.bottom + 6,
                                 width: scrollView.width - 60,
                                 height: scrollView.height - emailLabel.bottom - 200)
    }
    
    @objc func signOutButtonPressed() {
        navigationController?.popViewController(animated: true)
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

