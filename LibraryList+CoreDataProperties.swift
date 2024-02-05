//
//  LibraryList+CoreDataProperties.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/30/24.
//
//

import Foundation
import CoreData


extension LibraryList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LibraryList> {
        return NSFetchRequest<LibraryList>(entityName: "LibraryList")
    }

    @NSManaged public var libraryName: String?
    @NSManaged public var id: Int16

}

extension LibraryList : Identifiable {

}
