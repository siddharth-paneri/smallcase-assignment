//
//  HistoricalEntity+CoreDataClass.swift
//  smallcase
//
//  Created by Siddharth Paneri on 02/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData

@objc(HistoricalEntity)
public class HistoricalEntity: NSManagedObject {
    
    static var _dateFormatter: DateFormatter?
    
    class var dateFormatter : DateFormatter {
        guard let shared = _dateFormatter else {
            _dateFormatter = DateFormatter()
            _dateFormatter?.calendar = Calendar(identifier: .iso8601)
            _dateFormatter?.locale = Locale(identifier: "en_US_POSIX")
            _dateFormatter?.timeZone = TimeZone(secondsFromGMT: 0)
            _dateFormatter?.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" //"2018-11-21T03:04:13.959Z"
            return _dateFormatter!
        }
        return shared
    }
    
    /** Fetch the hostorical data from db, based on predicate */
    class func fetchHistorical(for scid: String, and duration: Duration) -> [HistoricalEntity] {
        /* Return Smallcase */
        let predicate = NSPredicate(format: "smallcase.scid =%@ AND duration == %@", scid, duration.rawValue)
        return HistoricalEntity.query(predicate, sort: ["date":"ASC"]) as! [HistoricalEntity]
        
    }
    
    /** Store the hostorical data in db, for specific smallcase and duration */
    class func storeHistorical(_ record: [String: Any], for duration: Duration) -> Bool{
        
        if let scid = record["scid"] as? String {
            
            HistoricalEntity.removeAllHistorical(for: scid, and: duration)
            
            if let points = record["points"] as? [[String: Any]] {
                for point in points {
                    if let dateString = point["date"] as? String {
                        if let date = HistoricalEntity.dateFormatter.date(from: dateString) {
                            if let index = point["index"] as? Double {
                                
                                let historicalObj = HistoricalEntity.create()
                                historicalObj.setValue(date, forKey: "date")
                                historicalObj.setValue(index, forKey: "index")
                                historicalObj.setValue(duration.rawValue, forKey: "duration")
                                if let smallcase = SmallcaseEntity.fetchSmallcase(scid) {
                                    historicalObj.setValue(smallcase, forKey: "smallcase")
                                }
                                _ = historicalObj.save()
                            }
                        }
                    }
                }
                return true
            }
        }
        return false
    }
    
    /** Remove smallcase historical data for a specific scid and duration */
    class func removeAllHistorical(for scid: String, and duration: Duration) {
        let historicalData = HistoricalEntity.fetchHistorical(for: scid, and: duration)
        for historical in historicalData {
            historical.delete()
            _ = historical.save()
        }
    }
    
}
