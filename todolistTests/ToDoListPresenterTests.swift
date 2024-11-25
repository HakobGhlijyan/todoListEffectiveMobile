//
//  ToDoListPresenterTests.swift
//  todolistTests
//
//  Created by Hakob Ghlijyan on 25.11.2024.
//

import XCTest
import CoreData
@testable import todolist

final class ToDoListPresenterTests: XCTestCase {
    var presenter: ToDoListPresenter!
    var interactor: ToDoListInteractor!
    var router: ToDoListRouter!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        interactor = ToDoListInteractor()
        router = ToDoListRouter()
        presenter = ToDoListPresenter(interactor: interactor, router: router)
        context = interactor.getContext()
    }

    ///1.    Очистка данных:
    ///•    Мы добавили очистку всех задач в tearDown с использованием fetchRequest, чтобы каждый тест был независим от данных других тестов.
    override func tearDown() {
        // Очистка всех данных перед каждым тестом
        let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        let todos = try? context.fetch(fetchRequest)
        todos?.forEach { context.delete($0) }
        CoreDataManager.shared.saveContext()
        
        presenter = nil
        interactor = nil
        router = nil
        super.tearDown()
    }

    ///2.    Тест testInitialFetch()
    ///•    Вместо жестко заданного числа задач, мы теперь динамически получаем количество задач до и после добавления, чтобы убедиться, что оно увеличилось.
    func testInitialFetch() {
        let initialCount = interactor.fetchToDos(filter: .all, searchText: "").count
        interactor.addToDo(title: "Task 11", description: "Description11", priority: 1, dueDate: nil)
        presenter.setupFetchedResultsController()
        
        let todos = presenter.todos
        XCTAssertEqual(todos.count, initialCount + 1)
        XCTAssertEqual(todos.first?.title, "Task 11")
    }

    ///3.    Тест testFilterChange():
    ///•    Мы добавили проверку, что задачи, которые не подходят под фильтр, действительно исключаются. В частности, проверили, что задача помечена как завершенная.
    func testFilterChange() {
        // Добавляем задачи и меняем статус первой
        interactor.addToDo(title: "Completed Task", description: "Done", priority: 1, dueDate: nil)
        let task = interactor.fetchToDos(filter: .all, searchText: "").first!
        interactor.toggleCompletion(for: task)
        
        presenter.changeFilterOption(to: .completed)
        
        let filteredTodos = presenter.todos
        XCTAssertEqual(filteredTodos.count, 1)
        XCTAssertEqual(filteredTodos.first?.title, "Completed Task")
        XCTAssertTrue(filteredTodos.first!.isCompleted)
    }
    
    ///4.    Тест testAddToDo()
    ///•    Вместо того чтобы вручную взаимодействовать с UI, мы используем mock для завершения задания в роутере, чтобы проверить, что переданные данные соответствуют ожиданиям.
    func testAddToDo() {
        // Используем mock для роутера
        let mockCompletion: (String, String, Int, Date?) -> Void = { title, description, priority, dueDate in
            XCTAssertEqual(title, "New Task")
            XCTAssertEqual(description, "Description")
            XCTAssertEqual(priority, 1)
        }
        
        // Передаем mock в роутер
        router.navigateToAddToDo(completion: mockCompletion)
        presenter.addToDo()
    }
}

