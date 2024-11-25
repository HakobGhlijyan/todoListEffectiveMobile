//
//  EditToDoView.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 25.11.2024.
//

import SwiftUI

struct EditToDoView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var presenter: ToDoListPresenter
    var todo: ToDo
    //View Property
    @State private var title: String
    @State private var descriptionText: String
    @State private var priority: Int
    @State private var dueDate: Date?
        
    init(todo: ToDo, presenter: ToDoListPresenter) {
        self.todo = todo
        _title = State(initialValue: todo.title ?? "")
        _descriptionText = State(initialValue: todo.descriptionText ?? "")
        _priority = State(initialValue: Int(todo.priority))
        _dueDate = State(initialValue: todo.dueDate)
        self.presenter = presenter
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Задача")) {
                    TextField("Заголовок", text: $title)
                        .textFieldStyle(.roundedBorder)
                    TextField("Описание", text: $descriptionText)
                        .textFieldStyle(.roundedBorder)
                }
                Section(header: Text("Задача")) {
                    TextEditor(text: $title)
                        .frame(height: 50)
                    TextEditor(text: $descriptionText)
                        .frame(height: 150)
                }
                Section(header: Text("Задача")) {
                    DatePicker(
                        "Due Date",
                        selection: Binding(
                            get: { dueDate ?? Date() }, // Возвращаем current Date, если dueDate nil
                            set: { newDate in dueDate = newDate }
                        )
                    )
                        .datePickerStyle(.graphical)
                }
            }
            .navigationBarTitle("Редактировать", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отменить") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        saveChanges()
                        dismiss()
                    }
                    .disabled(title.isEmpty) // Запрещаем сохранить, если заголовок пустой
                }
            }
        }
    }
    
    private func saveChanges() {
        // Сохраняем изменения в задаче
        todo.title = title
        todo.descriptionText = descriptionText
        todo.priority = Int16(priority)
        todo.dueDate = dueDate
        presenter.updateToDo(todo)
    }
}
