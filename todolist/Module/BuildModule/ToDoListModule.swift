//
//  ToDoListModule.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 19.11.2024.
//

import SwiftUI

struct ToDoListModule {
    static func build() -> some View {
        let interactor = ToDoListInteractor()
        let router = ToDoListRouter()
        let presenter = ToDoListPresenter(interactor: interactor, router: router)
        return ToDoListView(presenter: presenter)
    }
}
