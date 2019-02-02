//
//  HistoricalDataController.swift
//  smallcase
//
//  Created by Siddharth Paneri on 02/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation



class SmallcaseHistoryParser {
    
    class func parse(_ historicalEntity: HistoricalEntity) -> SmallcaseHistory {
        return SmallcaseHistory.init(date: historicalEntity.date as! Date, indexValue: historicalEntity.index)
    }
    
    class func parse(_ historicalEntities: [HistoricalEntity]) -> [SmallcaseHistory] {
        var smallcaseHistories: [SmallcaseHistory] = []
        for historical in historicalEntities {
            let smallcaseHistory = SmallcaseHistory.init(date: historical.date as! Date, indexValue: historical.index)
            smallcaseHistories.append(smallcaseHistory)
        }
        return smallcaseHistories
    }
    
    
}

class HistoricalDataController {
    let dataProvider = DataProvider()
    
    func getHistoricalData(for scid: String, and duration: Duration , completion: @escaping ([SmallcaseHistory], Error?)->()) {
        dataProvider.getHistoricalData(for: scid, and: duration) { (historicalData, error) in
            if historicalData.count > 0 {
                let smallcaseHistory = SmallcaseHistoryParser.parse(historicalData)
                completion(smallcaseHistory, nil)
            } else {
                completion([], error)
            }
        }
    }
}
