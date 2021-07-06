//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by 18992227 on 05.07.2021.
//

import CoreData
import UIKit

final class TaskListViewController: UITableViewController {
    private static let cellId = "cell"
    
    private var tasks: [Task] = []

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        setupNavigationBar()
        
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchData()
    }
    
    // MARK: - Methods
    private func setupTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellId)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorInset = .zero
    }

    private func setupNavigationBar() {
        title = "Task List"

        navigationController?.navigationBar.prefersLargeTitles = true

        // Navigation bar appeareance
        let navBarAppereance = UINavigationBarAppearance()
        navBarAppereance.configureWithOpaqueBackground()

        navBarAppereance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppereance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navBarAppereance.backgroundColor = UIColor(named: "NavBarBg")

        navigationController?.navigationBar.standardAppearance = navBarAppereance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppereance

        // Add button to nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )

        navigationController?.navigationBar.tintColor = UIColor(named: "NavBarTint")
    }

    @objc private func addNewTask() {
        let taskVC = TaskViewController()
        
        taskVC.modalPresentationStyle = .fullScreen
        
        taskVC.taskAction = .create
        
        present(taskVC, animated: true)
    }

    private func fetchData() {
        tasks = storage().fetchTasks()
        
        tableView.reloadData()
    }
}

// MARK: - Table Data Source
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellId, for: indexPath)
        let task = tasks[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        
        if task.completed {
            content.image = UIImage(systemName: "checkmark.square")
            content.imageProperties.tintColor = .systemGreen
            cell.backgroundColor = UIColor(named: "completedTaskBg")
        } else {
            content.image = UIImage(systemName: "square")
            content.imageProperties.tintColor = .systemGray5
        }

        cell.contentConfiguration = content

        return cell
    }
}

// MARK: - Table Actions
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            let task = self.tasks[indexPath.row]
            
            self.tasks.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.storage().removeTask(task: task)
        }
        
        let completeAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            let task = self.tasks[indexPath.row]
        
            self.storage().updateTask(for: task, title: task.title ?? "", completed: !task.completed)
            
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        completeAction.image = UIImage(systemName: "checkmark.square")
        completeAction.backgroundColor = .systemGreen
        
        let configuration = UISwipeActionsConfiguration(actions: [completeAction, deleteAction])
        
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskVC = TaskViewController()
        let task = tasks[indexPath.row]
        
        taskVC.modalPresentationStyle = .fullScreen
        taskVC.task = task
        taskVC.taskAction = .update
        
        present(taskVC, animated: true)
    }
}
