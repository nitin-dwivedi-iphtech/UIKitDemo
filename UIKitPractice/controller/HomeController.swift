//
//  HomeViewController.swift
//  UIKitPractice
//
//  Created by iPHTech 40 on 17/08/26.
//

import UIKit
import Combine

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    private var viewModel :DashboardViewModel!
    private var appState: AppState!
    private var cancellable = Set<AnyCancellable>()
    
    func config(appState:AppState) {
        self.viewModel = DashboardViewModel(appState: appState)
        self.appState = appState
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.$todo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchTodo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let profileVC = segue.destination as? ProfileController {
            profileVC.config(appState: appState)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.todo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        if let todo = viewModel.todo{
            let task = todo[indexPath.row]
            cell.textLabel?.text = task.desc
            cell.detailTextLabel?.text = task.status
        }
        return cell
    }
    
    private func bindViewModel() {
        appState.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                if let user {
                    self?.userNameLabel.text = "Welcome \(user.name ?? "NA")!"
                }
            }
            .store(in: &cancellable)
    }
}
