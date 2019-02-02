//
//  HistoricalEntity+CoreDataProperties.swift
//  smallcase
//
//  Created by Siddharth Paneri on 02/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData


extension HistoricalEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoricalEntity> {
        return NSFetchRequest<HistoricalEntity>(entityName: "HistoricalEntity")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var duration: String?
    @NSManaged public var index: Double
    @NSManaged public var smallcase: SmallcaseEntity?

}
