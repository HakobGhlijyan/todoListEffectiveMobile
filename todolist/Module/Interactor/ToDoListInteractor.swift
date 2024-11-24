//
//  ToDoListInteractor.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 19.11.2024.
//

//1
/*
 import Foundation

 final class ToDoListInteractor {
     private var todos: [ToDo] = []

     func fetchToDos() -> [ToDo] {
         return todos
     }

     func addToDo(_ todo: ToDo) {
         todos.append(todo)
     }

     func deleteToDo(at index: Int) {
         todos.remove(at: index)
     }
 }
 */

import CoreData

final class ToDoListInteractor {
    private let context = CoreDataManager.shared.context

    func fetchToDos(filter: FilterOption) -> [ToDo] {
        let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
        switch filter {
        case .all:
            request.predicate = nil
        case .completed:
            request.predicate = NSPredicate(format: "isCompleted == true")
        case .active:
            request.predicate = NSPredicate(format: "isCompleted == false")
        }

        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching filtered ToDos: \(error)")
            return []
        }
    }
    
    func addToDo(_ title: String) {
        let newToDo = ToDo(context: context)
        newToDo.id = UUID()
        newToDo.title = title
        newToDo.isCompleted = false
        newToDo.dateCreated = Date()

        saveContext()
    }
    
    
    func deleteToDo(_ todo: ToDo) {
        context.delete(todo)
        saveContext()
    }
    
    func toggleCompletion(for todo: ToDo) {
        todo.isCompleted.toggle()
        saveContext()
    }
    
    private func saveContext() {
        CoreDataManager.shared.saveContext()
    }
}