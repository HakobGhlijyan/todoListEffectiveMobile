//
//  ToDoListPresenter.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 19.11.2024.
//

import Foundation

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
        self.todos = fetchedTodos

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
