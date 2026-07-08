import CoreData

public final class CoreDataStack {
    public let persistentContainer: NSPersistentContainer

    public init(modelName: String = "NewsPOC") {
        // SPMリソースとしてコンパイルされたモデル(momd)はBundle.moduleから明示的にロードする
        guard let modelURL = Bundle.module.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Core Data model: \(modelName)")
        }
        persistentContainer = NSPersistentContainer(name: modelName, managedObjectModel: model)
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data store failed to load: \(error)")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    public func newBackgroundContext() -> NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
}
