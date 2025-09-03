//
//  File.swift
//  Local
//
//  Created by Renan Germano on 02/09/25.
//

import Foundation
import Combine
import CoreData

/**
 An enum representing the possibles errors when trying to create an instance of `PersistenceController`.
 `PersistenceController` is necessary to create instances of repositories.
 */
public enum PersistenceControllerError: Error {
    /**
     Data model could not be properly localized with the given information (bundle; model name; model extension; store url [all these parameters contain default internal values]).
     */
    case dataModelNotFound(bundle: Bundle, modelName: String, modelExtension: String)
    
    /**
     Data model could be properly localized with the given information (bundle; model name; model extension; store url [all these parameters contain default internal values]) but failed to load persistent stores.
     */
    case persistentStoresLoadingFailed(Error)
}

/**
 An object that must be passed when creating instances of repositories.
 */
public final class PersistenceController {
    
    public let container: NSPersistentContainer
    
    /**
     Creates an instance of `PersistenceController`
     */
    public static func createInstance(
        bundle: Bundle? = nil,
        modelName: String? = nil,
        modelExtension: String? = nil,
        storeURL: URL? = nil
    ) -> AnyPublisher<PersistenceController, PersistenceControllerError> {
        let bundle = bundle ?? .module
        let modelName = modelName ?? Self.modelName
        let modelExtension = modelExtension ?? Self.modelExtension
        let storeURL = storeURL ?? Self.storeURL
        
        guard let modelURL = bundle.url(forResource: modelName, withExtension: modelExtension),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            return Fail<PersistenceController, PersistenceControllerError>(
                error: .dataModelNotFound(
                    bundle: bundle,
                    modelName: modelName,
                    modelExtension: modelExtension
                )
            )
            .eraseToAnyPublisher()
        }
        
        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        let desc = container.persistentStoreDescriptions.first ?? NSPersistentStoreDescription()
        desc.type = NSSQLiteStoreType
        desc.url = storeURL
        container.persistentStoreDescriptions = [desc]
        
        return Future<PersistenceController, PersistenceControllerError> { promise in
            container.loadPersistentStores { _, error in
                if let error {
                    promise(.failure(.persistentStoresLoadingFailed(error)))
                } else {
                    promise(.success(PersistenceController(container: container)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Internal
    
    init (container: NSPersistentContainer) {
        self.container = container
    }
    
    // MARK: - Private
    
    private static let modelName = "DataModel"
    private static let modelExtension = "momd"
    
    private static var storeURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = base.appendingPathComponent("DataKit", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("Data.sqlite")
    }
}

