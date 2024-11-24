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
    @State private var description: String = ""
    @State private var dateCreated: Date = Date()
    @State private var priority: Int = 1 // Низкий приоритет по умолчанию
    @State private var dueDate: Date = Date()
    
    @State private var showAlert: Bool = false
    var onSave: (String, String, Int, Date?) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(height: 200)
                }
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        Text("Low").tag(1)
                        Text("Medium").tag(2)
                        Text("High").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Due Date")) {
                    DatePicker("Select Due Date", selection: $dueDate, displayedComponents: [.date])
                }
                
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Please fill all fields and select due date that is today or newer."))
            }
            .navigationBarTitle("Add New ToDo", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(title, description, priority, dueDate)
                        dismiss()
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    Main()
}
