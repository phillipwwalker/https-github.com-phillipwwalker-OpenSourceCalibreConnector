//
//  Serieses+CoreDataProperties.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/15/24.
//
//

import Foundation
import CoreData


extension Serieses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Serieses> {
        return NSFetchRequest<Serieses>(entityName: "Serieses")
    }

    @NSManaged public var seriesName: String?
    @NSManaged public var works: NSSet?

}

// MARK: Generated accessors for works
extension Serieses {

    @objc(addWorksObject:)
    @NSManaged public func addToWorks(_ value: Books)

    @objc(removeWorksObject:)
    @NSManaged public func removeFromWorks(_ value: Books)

    @objc(addWorks:)
    @NSManaged public func addToWorks(_ values: NSSet)

    @objc(removeWorks:)
    @NSManaged public func removeFromWorks(_ values: NSSet)

}

extension Serieses : Identifiable {

}
