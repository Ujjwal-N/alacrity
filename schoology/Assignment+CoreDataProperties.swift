//
//  Assignment+CoreDataProperties.swift
//  schoology
//
//  Created by Ujjwal Nadhani on 10/7/18.
//  Copyright © 2018 Manoj M. All rights reserved.
//
//

import Foundation
import CoreData


extension Assignment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assignment> {
        return NSFetchRequest<Assignment>(entityName: "Assignment")
    }

    @NSManaged public var dueDate: NSDate
    @NSManaged public var name: String
    @NSManaged public var timeTook: Int16
    @NSManaged public var userCompleted: Bool
    @NSManaged public var period: Int16

}
