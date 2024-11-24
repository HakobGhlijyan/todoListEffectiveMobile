//
//  NetworkManager.swift
//  todolist
//
//  Created by Hakob Ghlijyan on 24.11.2024.
//

import SwiftUI

final class NetworkManager {
    static let shared = NetworkManager()

    private init() {}
    
    // Функция для загрузки задач из API Async
    func loadTodosFromAsync() async throws -> [TodoItemDTO] {
        let url = URL(string: "https://dummyjson.com/todos")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let todoResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
        return todoResponse.todos
    }
}

// Модель для данных, получаемых из API
struct TodoResponse: Codable {
    let todos: [TodoItemDTO]
}

struct TodoItemDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
