//
//  File.swift
//  
//
//  Created by Paul Wood on 7/24/19.
//

import Foundation
import CoreData

/// Swift Packages cannot load files which means our .xcdatamodel file will not load into the static library
/// and therefore we need to describe our Data Model in code, this is that work that describes a Lateral
/// and a list of Laterals, Each Lateral has a relationship to a List
let LateralManagedObjectModel: NSManagedObjectModel = {
  let lateral = NSEntityDescription ()
  lateral.name = "LateralMO" //MO means Managed Object
  lateral.managedObjectClassName = "LateralCoreData.LateralMO"

  let lateralBodyAttribute = NSAttributeDescription()
  lateralBodyAttribute.name = "body";
  lateralBodyAttribute.attributeType = .stringAttributeType;

  let lateralList = NSEntityDescription()
  lateralList.name = "LateralListMO" //MO means Managed Object
  lateralList.managedObjectClassName = "LateralCoreData.LateralListMO"

  let listBodyAttribute =  NSAttributeDescription()
  listBodyAttribute.name = "body"
  listBodyAttribute.attributeType = .stringAttributeType
  
  let lateralTitleAttribute =  NSAttributeDescription()
  lateralTitleAttribute.name = "title"
  lateralTitleAttribute.attributeType = .stringAttributeType

  // To-many relationship from "Element" to "Entry":
  let itemsRelation = NSRelationshipDescription()

  // To-one relationship from "Entry" to "Element":
  let listRelation = NSRelationshipDescription ()

  itemsRelation.name = "items"
  itemsRelation.destinationEntity = lateral
  itemsRelation.minCount = 0
  itemsRelation.maxCount = 0  // max = 0 for to-many relationship
  itemsRelation.deleteRule = .cascadeDeleteRule
  itemsRelation.inverseRelationship = listRelation

  listRelation.name = "lateralList"
  listRelation.destinationEntity = lateralList
  listRelation.minCount = 0
  listRelation.maxCount = 1 // max = 1 for to-one relationship
  listRelation.deleteRule = .nullifyDeleteRule
  listRelation.inverseRelationship = itemsRelation

  lateral.properties = [lateralBodyAttribute, listRelation]
  lateralList.properties = [listBodyAttribute, lateralTitleAttribute, itemsRelation]

  let mom = NSManagedObjectModel()
  mom.entities = [lateral, lateralList]
  return mom
}()
