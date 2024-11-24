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

    init(interactor: ToDoListInteractor, router: ToDoListRouter) {
        self.interactor = interactor
        self.router = router
        fetchToDos()
    }

    func fetchToDos() {
        todos = interactor.fetchToDos(filter: filterOption) // Передаем текущую опцию фильтра
    }

    func changeFilterOption(to option: FilterOption) {
        filterOption = option
        fetchToDos() // Перезагружаем задачи с новым фильтром
    }

//    func addToDo() {
//        router.navigateToAddToDo { [weak self] title in
//            self?.interactor.addToDo(title)
//            self?.fetchToDos()
//        }
//    }
    
    func addToDo() {
        router.navigateToAddToDo { [weak self] title, description in
            self?.interactor.addToDo(title: title, description: description)
            self?.fetchToDos()
        }
    }

    func delete(at offsets: IndexSet) {
        for index in offsets {
            interactor.deleteToDo(todos[index])
        }
        fetchToDos()
    }
    
    func delete(todo: ToDo) {
        interactor.deleteToDo(todo) // Удаляем элемент через Interactor
        fetchToDos() // Обновляем список задач
    }

    func toggleCompletion(for todo: ToDo) {
        interactor.toggleCompletion(for: todo)
        fetchToDos()
    }
}


/*
 
 func delete(todo: ToDo) {
     interactor.deleteToDo(todo) // Удаляем элемент через Interactor
     fetchToDos() // Обновляем список задач
 }
 
 List {
     ForEach(presenter.todos, id: \.id) { todo in
         HStack {
             Text(todo.title ?? "Untitled")
             Spacer()
             Button(action: {
                 presenter.delete(todo: todo) // Передаем объект для удаления
             }) {
                 Image(systemName: "trash")
                     .foregroundColor(.red)
             }
         }
     }
 }
 
 */
