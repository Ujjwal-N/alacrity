//
//  Section+CoreDataProperties.swift
//  schoology
//
//  Created by Ujjwal Nadhani on 10/7/18.
//  Copyright © 2018 Manoj M. All rights reserved.
//
//

import Foundation
import CoreData


extension Section {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Section> {
        return NSFetchRequest<Section>(entityName: "Section")
    }

    @NSManaged public var averageHomeworkTime: Int16
    @NSManaged public var color: String
    @NSManaged public var difficulty: Int16
    @NSManaged public var period: Int16
    @NSManaged public var preferredName: String
    @NSManaged public var schoologyID: String

}
