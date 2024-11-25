//
//  ToDoListRouter.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 19.11.2024.
//

import SwiftUI

final class ToDoListRouter {
    func navigateToAddToDo(completion: @escaping (String, String, Int, Date?) -> Void) {
        let inputView = ToDoInputView { title, description, priority, dueDate in
            completion(title, description, priority, dueDate)
        }
        let hostingController = UIHostingController(rootView: inputView)

        if let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first {
            rootViewController.present(hostingController, animated: true)
        }
    }
    func navigateToEditTodoView(todo: ToDo) {
        let editView = EditToDoView(todo: todo, presenter: ToDoListPresenter(interactor: ToDoListInteractor(), router: self))
        let hostingController = UIHostingController(rootView: editView)

        if let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first {
            rootViewController.present(hostingController, animated: true)
        }
    }
}


