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
    
    override func setUp() {
        super.setUp()
        interactor = ToDoListInteractor()
        router = ToDoListRouter()
        presenter = ToDoListPresenter(interactor: interactor, router: router)
    }
    
    override func tearDown() {
        presenter = nil
        interactor = nil
        router = nil
        super.tearDown()
    }
    
    func testInitialFetch() {
        interactor.addToDo(title: "Task 11", description: "Description11", priority: 1, dueDate: nil)
        presenter.setupFetchedResultsController()
        
        XCTAssertEqual(presenter.todos.count, 57)
        XCTAssertEqual(presenter.todos.first?.title, "Task 11")
    }
    
    func testFilterChange() {
        interactor.addToDo(title: "Completed Task", description: "Done", priority: 1, dueDate: nil)
        let task = interactor.fetchToDos(filter: .all, searchText: "").first!
        interactor.toggleCompletion(for: task)
        
        presenter.changeFilterOption(to: .completed)
        XCTAssertEqual(presenter.todos.count, 22)
        XCTAssertEqual(presenter.todos.first?.title, "Completed Task")
    }
    
    func testAddToDo() {
        presenter.addToDo()
        
        // Mock input for router completion
        router.navigateToAddToDo { title, description, priority, dueDate in
            XCTAssertEqual(title, "New Task")
            XCTAssertEqual(description, "Description")
            XCTAssertEqual(priority, 1)
        }
    }
}


