//
//  Vaccine+CoreDataProperties.swift
//  healthapp
//
//  Created by Wolfgang Walder on 01/08/19.
//  Copyright © 2019 Wolfgang Walder. All rights reserved.
//
//

import Foundation
import CoreData


extension Vaccine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vaccine> {
        return NSFetchRequest<Vaccine>(entityName: "Vaccine")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var dose: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var lot: String?
    @NSManaged public var name: String?
    @NSManaged public var vaccinationRecord: VaccinationRecord?

}
