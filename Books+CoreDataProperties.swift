//
//  Books+CoreDataProperties.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/15/24.
//
//

import Foundation
import CoreData


extension Books {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Books> {
        return NSFetchRequest<Books>(entityName: "Books")
    }

    @NSManaged public var bookRead: Bool
    @NSManaged public var calibreId: Int16
    @NSManaged public var comments: String?
    @NSManaged public var format: String?
    @NSManaged public var lastModify: Date?
    @NSManaged public var pubDate: Date?
    @NSManaged public var seriesIndex: Int16
    @NSManaged public var timeStamp: Date?
    @NSManaged public var title: String?
    @NSManaged public var library: String?
    @NSManaged public var narrator: String?
    @NSManaged public var uuid: String?
    @NSManaged public var cats: Set<Categories>
    @NSManaged public var pub: Publishers?
    @NSManaged public var readList: ReadingList?
    @NSManaged public var series: Serieses?
    @NSManaged public var writers: Set<Authors>

}

// MARK: Generated accessors for cats
extension Books {

    @objc(addCatsObject:)
    @NSManaged public func addToCats(_ value: Categories)

    @objc(removeCatsObject:)
    @NSManaged public func removeFromCats(_ value: Categories)

    @objc(addCats:)
    @NSManaged public func addToCats(_ values: NSSet)

    @objc(removeCats:)
    @NSManaged public func removeFromCats(_ values: NSSet)

}

// MARK: Generated accessors for writers
extension Books {

    @objc(addWritersObject:)
    @NSManaged public func addToWriters(_ value: Authors)

    @objc(removeWritersObject:)
    @NSManaged public func removeFromWriters(_ value: Authors)

    @objc(addWriters:)
    @NSManaged public func addToWriters(_ values: NSSet)

    @objc(removeWriters:)
    @NSManaged public func removeFromWriters(_ values: NSSet)

}

extension Books : Identifiable {

}
