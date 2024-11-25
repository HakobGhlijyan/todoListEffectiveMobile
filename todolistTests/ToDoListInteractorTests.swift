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
    
    override func tearDown() {
        interactor = nil
        context = nil
        super.tearDown()
    }
    
    func testAddToDo() {
        interactor.addToDo(title: "Task 1", description: "Description", priority: 1, dueDate: nil)
        let todos = interactor.fetchToDos(filter: .all, searchText: "")
        
        XCTAssertEqual(todos.count, 41) //task.count, now in 44 + 1 task = 45
        XCTAssertEqual(todos.first?.title, "Task 1")
    }
    
    func testDeleteToDo() {
        let newToDo = ToDo(context: context)
        newToDo.title = "Task to Delete"
        context.insert(newToDo)
        interactor.deleteToDo(newToDo)
        
        let todos = interactor.fetchToDos(filter: .all, searchText: "")
        XCTAssertFalse(todos.contains(newToDo))
    }
    
    func testFilterToDosBySearchText() {
        interactor.addToDo(title: "Task AAA", description: "Description AAA", priority: 1, dueDate: nil)
        interactor.addToDo(title: "Task BBB", description: "Description BBB", priority: 2, dueDate: nil)
        
        let filteredTodos = interactor.fetchToDos(filter: .all, searchText: "Task AA")
        XCTAssertEqual(filteredTodos.count, 1)
        XCTAssertEqual(filteredTodos.first?.title, "Task AA")
    }
}
