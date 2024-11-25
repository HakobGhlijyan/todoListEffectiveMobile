//
//  ToDoListInteractorTests.swift
//  todolistTests
//
//  Created by Hakob Ghlijyan on 25.11.2024.
//

import XCTest
import CoreData
@testable import todolist

final class ToDoListInteractorTests: XCTestCase {
    var interactor: ToDoListInteractor!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        interactor = ToDoListInteractor()
        context = CoreDataManager.shared.context
    }

    ///4.    Очистка данных в tearDown:
    ///•    В tearDown мы добавили код для очистки всех задач из Core Data после каждого теста, чтобы тесты не зависели от данных, созданных в других тестах.
    override func tearDown() {
        // Удаляем все задачи из CoreData для чистки между тестами
        let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        let todos = try? context.fetch(fetchRequest)
        todos?.forEach { context.delete($0) }
        CoreDataManager.shared.saveContext()
        
        interactor = nil
        context = nil
        super.tearDown()
    }

    ///1.    testAddToDo:
    ///•    Вместо жестко закодированного значения INT, теперь мы динамически получаем начальное количество задач, чтобы проверить, что оно увеличилось на 1 после добавления новой задачи.
    func testAddToDo() {
        let initialCount = interactor.fetchToDos(filter: .all, searchText: "").count
        
        // Добавляем новую задачу
        interactor.addToDo(title: "Task 1", description: "Description", priority: 1, dueDate: nil)
        
        let todos = interactor.fetchToDos(filter: .all, searchText: "")
        
        // Проверяем, что количество задач увеличилось на 1
        XCTAssertEqual(todos.count, initialCount + 1)
        XCTAssertEqual(todos.first?.title, "Task 1")
    }
    ///2.    testDeleteToDo:
    ///•    Мы добавляем задачу в context и сохраняем изменения через CoreDataManager.shared.saveContext(), чтобы убедиться, что задача действительно добавлена в контекст.
    ///•    После этого проверяем, что задача присутствует в списке перед удалением, и отсутствует после удаления.
    func testDeleteToDo() {
        let newToDo = ToDo(context: context)
        newToDo.title = "Task to Delete"
        context.insert(newToDo)
        CoreDataManager.shared.saveContext()
        
        // Проверяем, что задача была добавлена
        let todosBeforeDelete = interactor.fetchToDos(filter: .all, searchText: "")
        XCTAssertTrue(todosBeforeDelete.contains(newToDo))
        
        // Удаляем задачу
        interactor.deleteToDo(newToDo)
        
        // Проверяем, что задача была удалена
        let todosAfterDelete = interactor.fetchToDos(filter: .all, searchText: "")
        XCTAssertFalse(todosAfterDelete.contains(newToDo))
    }

    ///3.    testFilterToDosBySearchText:
    ///•    Мы добавляем несколько задач с различными заголовками и фильтруем задачи по тексту.
    ///•    Убедитесь, что тест правильно проверяет фильтрацию задач.
    func testFilterToDosBySearchText() {
        // Добавляем задачи с разными заголовками
        interactor.addToDo(title: "Task AAA", description: "Description AAA", priority: 1, dueDate: nil)
        interactor.addToDo(title: "Task BBB", description: "Description BBB", priority: 2, dueDate: nil)
        
        // Фильтруем задачи по части заголовка
        let filteredTodos = interactor.fetchToDos(filter: .all, searchText: "Task AA")
        
        // Проверяем, что найдена только одна задача
        XCTAssertEqual(filteredTodos.count, 1)
        XCTAssertEqual(filteredTodos.first?.title, "Task AAA")
    }
}
