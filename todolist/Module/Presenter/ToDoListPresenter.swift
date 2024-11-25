//
//  ToDoListPresenter.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 19.11.2024.
//

import Foundation
import CoreData

//OLD
/*
 enum FilterOption {
     case all
     case completed
     case active
 }

 final class ToDoListPresenter: ObservableObject {
     @Published var todos: [ToDo] = []
     private var filterOption: FilterOption = .all // По умолчанию показываем все задачи
     private let interactor: ToDoListInteractor
     private let router: ToDoListRouter
     private var searchText: String = "" // Текст поиска
     
     init(interactor: ToDoListInteractor, router: ToDoListRouter) {
         self.interactor = interactor
         self.router = router
         Task {
             await loadDataFromAPI()
         }
         fetchToDos()

     }
     
     // Обновленный метод для получения задач с учетом текста поиска
     func fetchToDos() {
         // Получаем задачи с учетом фильтров и поиска
         let fetchedTodos = interactor.fetchToDos(filter: filterOption, searchText: searchText)
         // Обновляем @Published свойство для перерисовки интерфейса
         DispatchQueue.main.async {
             self.todos = fetchedTodos // Убедитесь, что создается новый массив
         }
     }
     
     // Новый метод для фильтрации по поисковому тексту
     func filterToDos(by searchText: String) {
         self.searchText = searchText
         fetchToDos()
     }
     
     func loadDataFromAPI() async {
         do {
             try await CoreDataManager.shared.loadInitialDataFromAPI() // Загружаем данные только при первом запуске
             await MainActor.run {
                 self.fetchToDos()                                     // Обновляем список задач после загрузки
             }
         } catch {
             print("Ошибка загрузки данных из API: \(error)")
         }
     }
     
     func changeFilterOption(to option: FilterOption) {
         filterOption = option
         fetchToDos() // Перезагружаем задачи с новым фильтром

     }
     
     func addToDo() {
         router.navigateToAddToDo { [weak self] title, description, priority, dueDate in
             self?.interactor.addToDo(title: title, description: description, priority: priority, dueDate: dueDate)
             self?.fetchToDos()
         }
     }
     
     // Этот метод вызывается, чтобы перейти на экран редактирования задачи
     func navigateToEditTodoView(todo: ToDo) {
         router.navigateToEditTodoView(todo: todo)
         self.fetchToDos()
     }
     
     func delete(at offsets: IndexSet) {
         for index in offsets {
             interactor.deleteToDo(todos[index])
         }
         fetchToDos() // Обновляем список после удаления
     }
     
     func delete(todo: ToDo) {
         interactor.deleteToDo(todo) // Удаляем элемент через Interactor
         fetchToDos() // Обновляем список задач
     }
     
     func toggleCompletion(for todo: ToDo) {
         interactor.toggleCompletion(for: todo)
         fetchToDos()
     }
     
     // Метод для обновления задачи
     func updateToDo(_ todo: ToDo) {
         interactor.updateToDo(todo)
         fetchToDos()
     }
 }
 */

//NEW
enum FilterOption {
    case all
    case completed
    case active
}

final class ToDoListPresenter: NSObject, ObservableObject {
    @Published var todos: [ToDo] = []
    private var filterOption: FilterOption = .all // По умолчанию показываем все задачи
    private let interactor: ToDoListInteractor
    private let router: ToDoListRouter
    private var searchText: String = "" // Текст поиска
    
    private var fetchedResultsController: NSFetchedResultsController<ToDo>!
    
    init(interactor: ToDoListInteractor, router: ToDoListRouter) {
        self.interactor = interactor
        self.router = router
        super.init()
        Task {
            await loadDataFromAPI()
        }
//        fetchToDos()
        setupFetchedResultsController()

    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
        // Применяем фильтры и сортировку
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        // Добавляем предикат для фильтрации по статусу
        if filterOption == .completed {
            fetchRequest.predicate = NSPredicate(format: "isCompleted == true")
        } else if filterOption == .active {
            fetchRequest.predicate = NSPredicate(format: "isCompleted == false")
        }
        
        // Применяем поиск по тексту
        if !searchText.isEmpty {
            let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@ OR descriptionText CONTAINS[cd] %@", searchText, searchText)
            if let currentPredicate = fetchRequest.predicate {
                fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [currentPredicate, searchPredicate])
            } else {
                fetchRequest.predicate = searchPredicate
            }
        }
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: CoreDataManager.shared.context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            self.todos = fetchedResultsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch todos: \(error)")
        }
    }
    
    
    // Обновленный метод для получения задач с учетом текста поиска
//    func fetchToDos() {
//        // Получаем задачи с учетом фильтров и поиска
//        let fetchedTodos = interactor.fetchToDos(filter: filterOption, searchText: searchText)
//        // Обновляем @Published свойство для перерисовки интерфейса
//        DispatchQueue.main.async {
//            self.todos = fetchedTodos // Убедитесь, что создается новый массив
//        }
//    }
    
    // Новый метод для фильтрации по поисковому тексту
    func filterToDos(by searchText: String) {
        self.searchText = searchText
        setupFetchedResultsController()
    }
    
    func loadDataFromAPI() async {
        do {
            try await CoreDataManager.shared.loadInitialDataFromAPI() // Загружаем данные только при первом запуске
            await MainActor.run {
                self.setupFetchedResultsController()                                     // Обновляем список задач после загрузки
            }
        } catch {
            print("Ошибка загрузки данных из API: \(error)")
        }
    }
    
    func changeFilterOption(to option: FilterOption) {
        filterOption = option
        setupFetchedResultsController() // Перезагружаем задачи с новым фильтром

    }
    
    func addToDo() {
        router.navigateToAddToDo { [weak self] title, description, priority, dueDate in
            self?.interactor.addToDo(title: title, description: description, priority: priority, dueDate: dueDate)
            self?.setupFetchedResultsController()
        }
    }
    
    // Этот метод вызывается, чтобы перейти на экран редактирования задачи
    func navigateToEditTodoView(todo: ToDo) {
        router.navigateToEditTodoView(todo: todo)
        self.setupFetchedResultsController() // Обновляем данные
    }

    func delete(todo: ToDo) {
        interactor.deleteToDo(todo) // Удаляем элемент через Interactor
        setupFetchedResultsController() // Обновляем данные после удаления
    }
    
    func toggleCompletion(for todo: ToDo) {
        interactor.toggleCompletion(for: todo)
        setupFetchedResultsController() // Обновляем данные после изменения
    }
    
    // Метод для обновления задачи
    func updateToDo(_ todo: ToDo) {
        interactor.updateToDo(todo)
        setupFetchedResultsController() // Обновляем данные после обновления
    }
}


extension ToDoListPresenter: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Можно использовать, если нужно делать подготовку перед изменениями
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // После изменения данных обновляем список
        self.todos = fetchedResultsController.fetchedObjects ?? []
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        // Если нужно обработать изменения секций
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        // Если нужно обработать изменения объекта
    }
}
