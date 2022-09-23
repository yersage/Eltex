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
    
    var profileModel: ProfileModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = "Profile"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        profileModel = downloadProfileModel()
        
        view.addSubview(scrollView)
        scrollView.addSubview(roleIDLabel)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(tableView)
        
        roleIDLabel.text = "roleID: \(profileModel.roleId)"
        usernameLabel.text = "username: \(profileModel.username)"
        emailLabel.text = "email: \(profileModel.email ?? "is not provided")"
        
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
                                 height: emailLabel.bottom + 100)
    }
    
    private func downloadProfileModel() -> ProfileModel {
        guard let url = Bundle.main.url(forResource: "profile", withExtension: "json") else {
            fatalError("Failed to locate profile.json in app bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load profile.json in app bundle.")
        }
        
        profileModel = try! JSONDecoder().decode(ProfileModel.self, from: data)
        
        let decoder = JSONDecoder()
        
        guard let loadedProfileModel = try? decoder.decode(ProfileModel.self, from: data) else {
            fatalError("Failed to decode profile.json from app bundle.")
        }
        
        return loadedProfileModel
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileModel.permissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = profileModel.permissions[indexPath.row]
        return cell
    }
}

