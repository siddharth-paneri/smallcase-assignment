//
//  SmallcaseController.swift
//  smallcase
//
//  Created by Siddharth Paneri on 02/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation

class SmallcaseParser {
    
    class func parse(_ smallcaseEntity: SmallcaseEntity) -> Smallcase {
        return Smallcase.init(scid: smallcaseEntity.scid,
                              name: smallcaseEntity.name,
                              type: smallcaseEntity.type,
                              rationale: smallcaseEntity.rationale,
                              indexValue: smallcaseEntity.indexValue,
                              dailyReturn: smallcaseEntity.dailyReturn,
                              monthlyReturn: smallcaseEntity.monthlyReturn,
                              yearlyReturn: smallcaseEntity.yearlyReturn)
    }
    
    
}

class SmallcaseController {
    
    let dataProvider = DataProvider()
    
    func getAllSmalcases() -> [String] {
        return dataProvider.getAllSmallcases()
    }
    
    func getSmallcaseData(for scid: String, completion: @escaping (Smallcase?, Error?)->()) {
        dataProvider.getSmallcaseData(for: scid) { (smallcaseEntity, error) in
            if let entity = smallcaseEntity {
                let smallcase = SmallcaseParser.parse(entity)
                completion(smallcase, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    
}
