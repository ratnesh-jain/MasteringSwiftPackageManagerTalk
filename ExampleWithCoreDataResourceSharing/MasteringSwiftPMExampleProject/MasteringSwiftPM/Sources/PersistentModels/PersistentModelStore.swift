//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 06/09/24.
//

import Foundation
import CoreData

open class PersistentContainer: NSPersistentContainer {
    
}

public enum PersistentModelStore {
    public static let container: PersistentContainer = {
        guard let modelURL = Bundle.module.url(forResource: "PersistentModels", withExtension: "momd") else { fatalError() }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else { fatalError() }
        let container = PersistentContainer(name:"PersistentModels", managedObjectModel: model)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
