//
//  TaskViewController.swift
//  CoreDataDemo
//
//  Created by 18992227 on 05.07.2021.
//

import CoreData
import UIKit

enum TaskAction {
    case create, update
}

final class TaskViewController: UIViewController {
    var taskAction: TaskAction!
    var task: Task?
    
    private lazy var verticalStack: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 20
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 19)
        
        return label
    }()
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Task title"
        textField.textColor = .darkGray
        textField.borderStyle = .roundedRect
        
        return textField
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton()

        button.backgroundColor = UIColor(named: "saveButtonBg")

        button.setTitle("Save Task", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)

        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()

        button.backgroundColor = UIColor(named: "cancelButtonBg")

        button.setTitle("Cancel Task", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)

        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

        return button
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupViews([titleLabel, taskTextField, saveButton, cancelButton])
        
        setConstraints()
    }
    
    // MARK: - Methods
    private func setup() {
        view.backgroundColor = .white
        
        taskTextField.text = task?.title
        
        switch taskAction {
        case .create:
            titleLabel.text = "New task"
        case .update:
            titleLabel.text = "Update task"
        default:
            break
        }
    }

    private func setupViews(_ views: [UIView]) {
        view.addSubview(verticalStack)
        view.addSubview(titleLabel)
        
        views.forEach { verticalStack.addArrangedSubview($0) }
    }

    private func setConstraints() {
        verticalStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            verticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            verticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }

    @objc private func saveButtonTapped() {
        switch taskAction {
        case .create:
            storage().addTask(title: taskTextField.text)
        case .update:
            guard let task = task else { return }
            
            storage().updateTask(for: task, title: taskTextField.text ?? "")
        default:
            break
        }
        
        dismiss(animated: true)
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}
