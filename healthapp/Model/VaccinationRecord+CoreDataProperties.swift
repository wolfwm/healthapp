//
//  VaccinationRecord+CoreDataProperties.swift
//  healthapp
//
//  Created by Wolfgang Walder on 23/07/19.
//  Copyright © 2019 Wolfgang Walder. All rights reserved.
//
//

import Foundation
import CoreData


extension VaccinationRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VaccinationRecord> {
        return NSFetchRequest<VaccinationRecord>(entityName: "VaccinationRecord")
    }

    @NSManaged public var owner: String?
    @NSManaged public var id: UUID?
    @NSManaged public var vaccines: NSSet?

}

// MARK: Generated accessors for vaccines
extension VaccinationRecord {

    @objc(addVaccinesObject:)
    @NSManaged public func addToVaccines(_ value: Vaccine)

    @objc(removeVaccinesObject:)
    @NSManaged public func removeFromVaccines(_ value: Vaccine)

    @objc(addVaccines:)
    @NSManaged public func addToVaccines(_ values: NSSet)

    @objc(removeVaccines:)
    @NSManaged public func removeFromVaccines(_ values: NSSet)

}
