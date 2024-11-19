//
//  ToDoListRouter.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 19.11.2024.
//

import SwiftUI

final class ToDoListRouter {
    func navigateToAddToDo(completion: @escaping (ToDo) -> Void) {
        let newToDo = ToDoInputView { title in
            completion(ToDo(title: title))
        }
        let hostingController = UIHostingController(rootView: newToDo)
        UIApplication.shared.windows.first?.rootViewController?.present(hostingController, animated: true)
    }
}
