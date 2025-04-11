import Foundation
import UIKit
import CoreData

// Protocol for persistent storage
protocol PersistentStorageProtocol {
    func saveContext()
    func fetchEntities<T: NSManagedObject>(_ entityType: T.Type, predicate: NSPredicate?) -> [T]
    func createEntity<T: NSManagedObject>(_ entityType: T.Type) -> T
    func deleteEntity<T: NSManagedObject>(_ entity: T)
    func deleteAllEntities<T: NSManagedObject>(_ entityType: T.Type)
}

// Core Data storage implementation
class CoreDataManager: PersistentStorageProtocol {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    // Core Data context from AppDelegate
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // Save context
    func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    // Fetch entities
    func fetchEntities<T: NSManagedObject>(_ entityType: T.Type, predicate: NSPredicate? = nil) -> [T] {
        let entityName = String(describing: entityType)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching \(entityName): \(error)")
            return []
        }
    }
    
    // Create entity
    func createEntity<T: NSManagedObject>(_ entityType: T.Type) -> T {
        let entityName = String(describing: entityType)
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            fatalError("Failed to create entity: \(entityName)")
        }
        
        return T(entity: entity, insertInto: context)
    }
    
    // Delete entity
    func deleteEntity<T: NSManagedObject>(_ entity: T) {
        context.delete(entity)
        saveContext()
    }
    
    // Delete all entities of type
    func deleteAllEntities<T: NSManagedObject>(_ entityType: T.Type) {
        let entityName = String(describing: entityType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Error deleting all \(entityName): \(error)")
        }
    }
}
