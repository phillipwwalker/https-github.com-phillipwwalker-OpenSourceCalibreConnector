//
//  Authors+CoreDataProperties.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/15/24.
//
//

import Foundation
import CoreData


extension Authors {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Authors> {
        return NSFetchRequest<Authors>(entityName: "Authors")
    }

    @NSManaged public var name: String?

}

extension Authors : Identifiable {

}
