//
//  todolistApp.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 19.11.2024.
//

import SwiftUI
import CoreData

/*
 @main
 struct todolistApp: App {
     var body: some Scene {
         WindowGroup {
             Main()
         }
     }
 }

 */

@main
struct todolistApp: App {
    @StateObject private var persistenceController = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            Main()
                .onAppear {
                    Task {
                        await loadInitialDataIfNeeded()
                    }
                }
        }
    }

    private func loadInitialDataIfNeeded() async {
        let context = persistenceController.context
        let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()

        do {
            let existingToDos = try context.fetch(fetchRequest)
            if existingToDos.isEmpty {
                // Если задач нет, загружаем данные с API
                do {
                    let todos = try await NetworkManager.shared.loadTodosFromAsync()
                    await MainActor.run {
                        for todoDTO in todos {
                            let todo = ToDo(context: context)
                            todo.id = UUID()
                            todo.title = todoDTO.todo
                            todo.descriptionText = "No description available" // Пример описания
                            todo.priority = 1 // Пример значения
                            todo.dueDate = nil // Можно задать dueDate, если он есть в API
                            todo.isCompleted = todoDTO.completed
                            todo.dateCreated = Date()
                        }
                        persistenceController.saveContext()
                    }
                } catch {
                    print("Error loading todos from API: \(error)")
                }
            }
        } catch {
            print("Error fetching ToDos from Core Data: \(error)")
        }
    }
}

/*
 1.    Асинхронная загрузка при onAppear:
 •    Загрузка данных из API обёрнута в Task и выполняется внутри await.
 •    Это гарантирует выполнение асинхронной задачи при старте приложения.
 2.    Использование MainActor.run:
 •    Core Data требует работы с объектами контекста только на главном потоке. Поэтому мы используем MainActor.run для создания объектов в context.
 3.    Сохранение данных в CoreDataManager:
 •    После загрузки и создания объектов в контексте данные сохраняются вызовом saveContext.
 4.    Исправлены возможные ошибки:
 •    Например, дублирующее сохранение или выполнение задач вне главного потока.
 */
