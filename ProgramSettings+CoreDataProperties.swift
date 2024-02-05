//
//  ProgramSettings+CoreDataProperties.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 2/3/24.
//
//

import Foundation
import CoreData


extension ProgramSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgramSettings> {
        return NSFetchRequest<ProgramSettings>(entityName: "ProgramSettings")
    }

    @NSManaged public var calibreServer: String?
    @NSManaged public var collection_lable: String?
    @NSManaged public var curLibrary: String?
    @NSManaged public var defaultLibrary: String?
    @NSManaged public var delay: Int16
    @NSManaged public var ebookType: String?
    @NSManaged public var read_lable: String?
    @NSManaged public var reading_list_label: String?
    @NSManaged public var showThumbnail: Bool
    @NSManaged public var titleSort: String?
    @NSManaged public var authorSort: String?
    @NSManaged public var seriesSort: String?
    @NSManaged public var categorySort: String?

}

extension ProgramSettings : Identifiable {

}
