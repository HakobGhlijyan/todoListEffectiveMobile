//
//  ToDoInputView.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 19.11.2024.
//

import SwiftUI

struct ToDoInputView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var descriptionText: String = ""
    @State private var dateCreated: Date = Date()
    @State private var priority: Int = 1 // Низкий приоритет по умолчанию
    @State private var dueDate: Date = Date()
    @State private var includeDueDate: Bool = false
    @State private var includePriority: Bool = false
    var onSave: (String, String, Int, Date?) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Задача")) {
                    TextField("", text: $title)
                }
                Section(header: Text("Описание")) {
                    TextEditor(text: $descriptionText)
                        .frame(height: 50)
                }
                Section(header: Text("Приоритет ")) {
                    Toggle("Приоритет", isOn: $includePriority)
                    if includePriority {
                        Picker("Приоритет", selection: $priority) {
                            Text("Нет").tag(0)
                            Text("Низкий").tag(1)
                            Text("Средний").tag(2)
                            Text("Высокий").tag(3)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                }
                Section(header: Text("Дата")) {
                    Toggle("Дата окончания", isOn: $includeDueDate)
                    if includeDueDate {
                        DatePicker("Select Due Date", selection: $dueDate)
                            .datePickerStyle(.graphical)
                    }
                }
                
            }
            .navigationBarTitle("Add New ToDo", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        onSave(title, descriptionText, includePriority ? priority : 0, includeDueDate ? dueDate : nil)
                        dismiss()
                    }
                    .disabled(isValidInput())
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отменить") {
                        dismiss()
                    }
                }
            }
        }
    }
    private func isValidInput() -> Bool {
        title.isEmpty || descriptionText.isEmpty
    }
}

#Preview {
    Main()
}
