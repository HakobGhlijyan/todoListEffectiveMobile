//
//  todolistTests.swift
//  todolistTests
//
//  Created by Hakob Ghlijyan on 25.11.2024.
//

import XCTest
import CoreData
@testable import todolist

final class CoreDataManagerTests: XCTestCase {
    var coreDataManager: CoreDataManager!
    var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager.shared
        mockContext = coreDataManager.context
    }
    
    override func tearDown() {
        coreDataManager = nil
        mockContext = nil
        super.tearDown()
    }
    
    func testSaveToDo() {
        let newToDo = ToDo(context: mockContext)
        newToDo.id = UUID()
        newToDo.title = "Test Task"
        newToDo.isCompleted = false
        
        coreDataManager.saveContext()
        
        let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        let results = try? mockContext.fetch(fetchRequest)
        
        XCTAssertNotNil(results)
        XCTAssertTrue(results!.contains(where: { $0.title == "Test Task" }))
    }
}

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
        
        XCTAssertEqual(todos.count, 46) //task.count, now in 44 + 1 task = 45
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
        interactor.addToDo(title: "Task AA", description: "Description AA", priority: 1, dueDate: nil)
        interactor.addToDo(title: "Task BB", description: "Description BB", priority: 2, dueDate: nil)
        
        let filteredTodos = interactor.fetchToDos(filter: .all, searchText: "Task AA")
        XCTAssertEqual(filteredTodos.count, 1)
        XCTAssertEqual(filteredTodos.first?.title, "Task AA")
    }
}

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
        presenter.fetchToDos()
        
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


