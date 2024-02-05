//
//  ReadingList+CoreDataProperties.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/15/24.
//
//

import Foundation
import CoreData


extension ReadingList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReadingList> {
        return NSFetchRequest<ReadingList>(entityName: "ReadingList")
    }

    @NSManaged public var bookTitle: String?
    @NSManaged public var calibreId: Int16
    @NSManaged public var sortOrder: Int16

}

extension ReadingList : Identifiable {

}
