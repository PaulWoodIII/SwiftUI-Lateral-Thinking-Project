//
//  AppPersistentContainerBuilder.swift
//  LateralThinking-Persistance
//
//  Created by Paul Wood on 8/10/19.
//  Copyright © 2019 Paul Wood. All rights reserved.
//

import CoreData
import LateralThinkingCore

public class AppPersistentContainerBuilder {
  
  static let sqliteFileName = "lateralThinkingAppGroup.sqlite"
  
  public static var persistentContainer: NSPersistentContainer {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let bundle = Bundle(for: Self.self)
    let modelURL = bundle.url(forResource: CoreDataModelName, withExtension: "momd")!
    let mom = NSManagedObjectModel(contentsOf: modelURL)!
    let container = NSPersistentContainer(name: CoreDataModelName,
                                          managedObjectModel: mom)
    let persistentStoreDescription = container.persistentStoreDescriptions.first
    //let fileLocation = FileManager.applicationGroupDocumentDirectory.appendingPathComponent(sqliteFileName)
    //try addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: fileLocation, options: options)
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }
}
