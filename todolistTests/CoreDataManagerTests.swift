//
//  CoreDataManagerTests.swift
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
