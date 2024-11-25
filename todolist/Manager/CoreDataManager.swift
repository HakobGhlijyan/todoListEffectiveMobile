//
//  CoreDataManager.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 19.11.2024.
//

import CoreData

final class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error.localizedDescription)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save Core Data context: \(error)")
            }
        }
    }
    
    func loadInitialDataFromAPI() async throws {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "isDataLoaded")
        guard isFirstLaunch else { return }

        let todos = try await NetworkManager.shared.loadTodosFromAsync()
        saveTodosToCoreData(todos)

        UserDefaults.standard.set(true, forKey: "isDataLoaded")
    }
    
    func saveTodosToCoreData(_ todos: [TodoItemDTO]) {
        let context = CoreDataManager.shared.context

        let existingIDs: Set<UUID> = {
            let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
            fetchRequest.propertiesToFetch = ["id"]
            let results = (try? context.fetch(fetchRequest)) ?? []
            return Set(results.compactMap { $0.id })
        }()

        for todoDTO in todos where !existingIDs.contains(UUID()) {
            let todo = ToDo(context: context)
            todo.id = UUID()
            todo.title = todoDTO.todo
            todo.descriptionText = "No description available"
            todo.priority = 1
            todo.dueDate = nil
            todo.isCompleted = todoDTO.completed
            todo.dateCreated = Date()
        }

        CoreDataManager.shared.saveContext()
    }
    
}
