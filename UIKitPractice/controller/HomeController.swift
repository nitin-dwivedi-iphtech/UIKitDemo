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
        tableView.refreshControl = setUpRefreshController()
        viewModel.$todo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellable)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.fetchTodo()
    }
    
    private func setUpRefreshController() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: "ThemeAccent")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTodo), for: .valueChanged)
        return refreshControl
    }
    
    @objc private func refreshTodo() {
        viewModel.fetchTodo()
        tableView.refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchTodo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let profileVC = segue.destination as? ProfileController {
            profileVC.config(appState: appState)
        } else if let addVC = segue.destination as? AddTodoController {
            addVC.config(viewModel: viewModel)
            addVC.modalPresentationStyle = .pageSheet
            addVC.onSave = { [weak self] in self?.viewModel.fetchTodo() }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.todo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? TodoCell,
              let task = viewModel.todo?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let task = viewModel.todo?[indexPath.row] else { return nil }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completion in
            self?.openEditScreen(for: task)
            completion(true)
        }
        editAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let task = viewModel.todo?[indexPath.row] else { return nil }
        
        let isCompleted = StatusEnum.from(task.status) == .completed
        let toggleAction = UIContextualAction(style: .normal, title: isCompleted ? "Mark Pending" : "Complete") { [weak self] _, _, completion in
            self?.viewModel.toggleStatus(for: task)
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        toggleAction.backgroundColor = isCompleted ? .systemOrange : .systemGreen
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.viewModel.deleteTodo(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [toggleAction, deleteAction])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTodo(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func openEditScreen(for task: Todo) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addVC = storyboard.instantiateViewController(withIdentifier: "AddTodoController") as? AddTodoController else { return }
        addVC.config(viewModel: viewModel)
        addVC.todoToEdit = task
        addVC.modalPresentationStyle = .pageSheet
        addVC.onSave = { [weak self] in self?.viewModel.fetchTodo() }
        present(addVC, animated: true)
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
