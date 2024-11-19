//
//  ToDoListPresenter.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 19.11.2024.
//

import Foundation

final class ToDoListPresenter: ObservableObject {
    @Published var todos: [ToDo] = []
    private let interactor: ToDoListInteractor
    private let router: ToDoListRouter

    init(interactor: ToDoListInteractor, router: ToDoListRouter) {
        self.interactor = interactor
        self.router = router
        fetchToDos()
    }

    func fetchToDos() {
        todos = interactor.fetchToDos()
    }

    func addToDo() {
        router.navigateToAddToDo { [weak self] newToDo in
            self?.interactor.addToDo(newToDo)
            self?.fetchToDos()
        }
    }

    func delete(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        interactor.deleteToDo(at: index)
        fetchToDos()
    }
}
