//
//  ToDoListView.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 19.11.2024.
//

import SwiftUI

struct ToDoListView: View {
    @ObservedObject var presenter: ToDoListPresenter

    var body: some View {
        NavigationStack {
            List {
                ForEach(presenter.todos) { todo in
                    Text(todo.title)
                }
                .onDelete { indexSet in
                    presenter.delete(at: indexSet)
                }
            }
            .navigationTitle("To-Do List")
            .toolbar {
                Button(action: {
                    presenter.addToDo()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
