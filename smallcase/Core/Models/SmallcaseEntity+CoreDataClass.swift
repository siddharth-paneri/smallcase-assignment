//
//  SmallcaseEntity+CoreDataClass.swift
//  smallcase
//
//  Created by Siddharth Paneri on 02/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftRecord

@objc(SmallcaseEntity)
public class SmallcaseEntity: NSManagedObject {

    /** Fetch smallcase from db based on scid */
    class func fetchSmallcase(_ scid: String) -> SmallcaseEntity? {
        /* Return Smallcase */
        return SmallcaseEntity.find("scid = %@", args: scid) as? SmallcaseEntity
    }
    
    /** Create a smallcase entry in db */
    class func createSmallcase(_ record: [String: Any]) -> Bool{

        if let scid = record["scid"] as? String {
            var coreDataObj: NSManagedObject? = nil
            if let smallcase = SmallcaseEntity.fetchSmallcase(scid) {
                coreDataObj = smallcase
            } else {
                coreDataObj = SmallcaseEntity.create()
            }

            guard let smallcase = coreDataObj else {
                return false
            }

            smallcase.setValue(scid, forKey: "scid")
            
            if let rationale = record["rationale"] as? String {
                smallcase.setValue(rationale, forKey: "rationale")
            }
            
            if let info = record["info"] as? [String: Any] {
                if let name = info["name"] as? String {
                    smallcase.setValue(name, forKey: "name")
                }
                
                if let type = info["type"] as? String {
                    smallcase.setValue(type, forKey: "type")
                }
            }
            
            if let stats = record["stats"] as? [String: Any] {
                if let indexValue = stats["indexValue"] as? Double {
                    smallcase.setValue(NSNumber(value: indexValue), forKey: "indexValue")
                }
                
                if let returns = stats["returns"] as? [String: Any] {
                    if let daily = returns["daily"] as? Double {
                        smallcase.setValue(daily, forKey: "dailyReturn")
                    }
                    if let monthly = returns["monthly"] as? Double {
                        smallcase.setValue(monthly, forKey: "monthlyReturn")
                    }
                    if let yearly = returns["yearly"] as? Double {
                        smallcase.setValue(yearly, forKey: "yearlyReturn")
                    }
                }
            }
            
            return smallcase.save()
        }
        
        return false
    }
    
    
}
