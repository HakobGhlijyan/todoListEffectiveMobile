//
//  ToDoListView.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 19.11.2024.
//

import SwiftUI

struct ToDoListView: View {
    @ObservedObject var presenter: ToDoListPresenter
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if presenter.todos.isEmpty {
                    ContentUnavailableView(
                        "Your Task",
                        systemImage: "list.bullet.clipboard",
                        description: Text(
                            "Please Add new task"
                        )
                    )
                } else {
                    ForEach(presenter.todos, id: \.id) { todo in
                        ToDoItemRow(todo: todo)
                            .onTapGesture {
                                presenter.toggleCompletion(for: todo)
                            }
                            .contextMenu {
                                VStack {
                                    Button {
                                        print("Редактировать")
                                    } label: {
                                        HStack {
                                            Image(systemName: "highlighter")
                                            Text("Редактировать")
                                        }
                                    }
                                    Button {
                                        print("Поделиться")
                                    } label: {
                                        HStack {
                                            Image(systemName: "square.and.arrow.up")
                                            Text("Поделиться")
                                        }
                                    }
                                    Button(role: .destructive) {
                                        presenter.delete(todo: todo)
                                    } label: {
                                        HStack {
                                            Image(systemName: "trash")
                                            Text("Удалить")
                                        }
                                    }
                                }
                            }
                    }
                    .onDelete { indexSet in
                        presenter.delete(at: indexSet)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Задачи")
            .toolbarBackground(.visible, for: .bottomBar)
            .toolbarBackground(.ultraThickMaterial, for: .bottomBar)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
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
                ToolbarItem(placement: .status) {
                    Text("\(presenter.todos.count) Задач")
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        presenter.addToDo()
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .searchable(text: $searchText)
        }
    }
    
    @ViewBuilder func ToDoItemRow(todo: ToDo) -> some View {
        VStack(spacing: 0.0) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: todo.isCompleted ? "checkmark.circle" : "circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 48)
                    .foregroundStyle(todo.isCompleted ? Color.accentColor : Color.primary)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 0.0) {
                        Text(todo.title ?? "Your title")
                            .font(.headline)
                            .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                            .strikethrough(todo.isCompleted ? true : false)
                         Spacer()
                         Text(priorityText(for: todo.priority))
                             .font(.subheadline)
                             .foregroundColor(priorityColor(for: todo.priority))
                    }
                    
                    Text(todo.descriptionText ?? " Your descriprion text")
                        .font(.subheadline)
                        .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                    
                    Text("Создана: \(todo.dateCreated ?? Date(), formatter: itemFormatter)")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    if let dueDate = todo.dueDate {
                        Text("Дата завершения до: \(dueDate, formatter: itemFormatter)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
                .padding(.horizontal, 20)
        }
        .background(.black.opacity(0.0001))
    }

    private func priorityText(for priority: Int16) -> String {
        switch priority {
        case 1: return "Low"
        case 2: return "Medium"
        case 3: return "High"
        default: return ""
        }
    }

    private func priorityColor(for priority: Int16) -> Color {
        switch priority {
        case 1: return .green
        case 2: return .orange
        case 3: return .red
        default: return .gray
        }
    }
}


#Preview {
    Main()
//        .preferredColorScheme(.dark)
}
