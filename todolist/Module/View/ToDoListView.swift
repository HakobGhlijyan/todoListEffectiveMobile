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
                ForEach(presenter.todos, id: \.id) { todo in
                    HStack {
                        Text(todo.title ?? "Untitled")
                        Spacer()
                        Button(action: {
                            presenter.toggleCompletion(for: todo)
                        }) {
                            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                        }
                    }
                }
                .onDelete { indexSet in
                    presenter.delete(at: indexSet)
                }
            }
            .navigationTitle("To-Do List")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("Show All") {
                            presenter.changeFilterOption(to: .all)
                        }
                        Button("Show Completed") {
                            presenter.changeFilterOption(to: .completed)
                        }
                        Button("Show Active") {
                            presenter.changeFilterOption(to: .active)
                        }
                    } label: {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        presenter.addToDo()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}
