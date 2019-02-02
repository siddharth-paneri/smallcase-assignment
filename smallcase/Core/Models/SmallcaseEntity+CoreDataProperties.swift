//
//  SmallcaseEntity+CoreDataProperties.swift
//  smallcase
//
//  Created by Siddharth Paneri on 02/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData

extension SmallcaseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SmallcaseEntity> {
        return NSFetchRequest<SmallcaseEntity>(entityName: "SmallcaseEntity")
    }

    @NSManaged public var dailyReturn: Double
    @NSManaged public var indexValue: Double
    @NSManaged public var monthlyReturn: Double
    @NSManaged public var name: String?
    @NSManaged public var rationale: String?
    @NSManaged public var scid: String?
    @NSManaged public var type: String?
    @NSManaged public var yearlyReturn: Double
    @NSManaged public var historicalData: NSSet?

}

// MARK: Generated accessors for historicalData
extension SmallcaseEntity {

    @objc(addHistoricalDataObject:)
    @NSManaged public func addToHistoricalData(_ value: HistoricalEntity)

    @objc(removeHistoricalDataObject:)
    @NSManaged public func removeFromHistoricalData(_ value: HistoricalEntity)

    @objc(addHistoricalData:)
    @NSManaged public func addToHistoricalData(_ values: NSSet)

    @objc(removeHistoricalData:)
    @NSManaged public func removeFromHistoricalData(_ values: NSSet)

}
