// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import CoreData
import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable attributes file_length vertical_whitespace_closing_braces
// swiftlint:disable identifier_name line_length type_body_length

// MARK: - LateralListMO

internal class LateralListMO: NSManagedObject {
  internal class func entityName() -> String {
    return "LateralListMO"
  }

  internal class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
  }

  @nonobjc internal class func fetchRequest() -> NSFetchRequest<LateralListMO> {
    return NSFetchRequest<LateralListMO>(entityName: entityName())
  }

  // swiftlint:disable discouraged_optional_boolean discouraged_optional_collection
  @NSManaged internal var body: String?
  @NSManaged internal var title: String?
  @NSManaged internal var items: LateralMO?
  // swiftlint:enable discouraged_optional_boolean discouraged_optional_collection
}

// MARK: - LateralMO

internal class LateralMO: NSManagedObject {
  
  internal class func entityName() -> String {
    return "LateralMO"
  }

  internal class func entity(in managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
    return NSEntityDescription.entity(forEntityName: entityName(), in: managedObjectContext)
  }

  @nonobjc internal class func fetchRequest() -> NSFetchRequest<LateralMO> {
    return NSFetchRequest<LateralMO>(entityName: entityName())
  }

  // swiftlint:disable discouraged_optional_boolean discouraged_optional_collection
  @NSManaged internal var body: String?
  @NSManaged internal var lateralList: LateralListMO?
  // swiftlint:enable discouraged_optional_boolean discouraged_optional_collection
}

// swiftlint:enable identifier_name line_length type_body_length
