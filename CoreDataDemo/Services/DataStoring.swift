//
//  DataStoring.swift
//  CoreDataDemo
//
//  Created by SERGEY VOROBEV on 06.07.2021.
//

import Foundation

protocol DataStoring {
    func addTask(title: String?)
    func fetchTasks() -> [Task]
    func updateTask(for task: Task, title: String)
    func removeTask(task: Task)
    func save()
}
