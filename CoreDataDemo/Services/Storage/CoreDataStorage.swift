//
//  CoreDataStorage.swift
//  CoreDataDemo
//
//  Created by SERGEY VOROBEV on 06.07.2021.
//

import CoreData

class CoreDataStorage: DataStoring {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func addTask(title: String?) {
        let viewContext = persistentContainer.viewContext
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: viewContext) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Task else { return }
     
        task.title = title
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func fetchTasks() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        
        return []
    }
    
    func updateTask(for task: Task, title: String, completed: Bool) {
        task.title = title
        task.completed = completed
        
        self.save()
    }
    
    func removeTask(task: Task) {
        persistentContainer.viewContext.delete(task)
        
        self.save()
    }
    
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
