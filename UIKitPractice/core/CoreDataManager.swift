//
//  CoreDataManager.swift
//  UIKitPractice
//
//  Created by iPHTech 40 on 19/08/26.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer  = {
        let container = NSPersistentContainer(name: "AppModel")
        container.loadPersistentStores{_,error in
            if let error = error as NSError? {
                fatalError("Core Data store failed...")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
    
}
