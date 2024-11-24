//
//  ToDoListRouter.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 19.11.2024.
//

import SwiftUI

/*
 final class ToDoListRouter {
     func navigateToAddToDo(completion: @escaping (String) -> Void) {
         let newToDoInputView = ToDoInputView { title in
             completion(title) // Передаем только текст, создание объекта произойдет в Interactor
         }
         let hostingController = UIHostingController(rootView: newToDoInputView)

         // Получаем текущий rootViewController для презентации
         if let rootViewController = UIApplication.shared.connectedScenes
             .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
             .first {
             rootViewController.present(hostingController, animated: true)
         }
     }
 }


final class ToDoListRouter {
    func navigateToAddToDo(completion: @escaping (String, String) -> Void) {
        let newToDoInputView = ToDoInputView { title, description in
            completion(title, description) // Передаем заголовок и описание
        }
        let hostingController = UIHostingController(rootView: newToDoInputView)

        // Получаем текущий rootViewController для презентации
        if let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first {
            rootViewController.present(hostingController, animated: true)
        }
    }
}
 */


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
}
