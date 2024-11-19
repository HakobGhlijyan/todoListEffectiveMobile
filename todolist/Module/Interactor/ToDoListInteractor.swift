//
//  ToDoListInteractor.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 19.11.2024.
//

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
