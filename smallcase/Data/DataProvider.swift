//
//  DataProvider.swift
//  smallcase
//
//  Created by Siddharth Paneri on 02/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation


class DataProvider {
    
    
    func getAllSmallcases() -> [String] {
        return ["SCMO_0002", "SCMO_0003", "SCMO_0006", "SCNM_0003", "SCNM_0007", "SCNM_0008", "SCNM_0009" ]
    }
    
    /** Used to get the parsed response from API from CommsProvider */
    
    func getSmallcaseData(for scid: String, completion: @escaping (SmallcaseEntity?, Error?)->()) {
        
        CommsProvider.isUnreachable { _ in
            if let smallcaseEntity = SmallcaseEntity.fetchSmallcase(scid) {
                completion(smallcaseEntity, nil)
            } else {
                print("DataProvider: could not fetch data from Core data")
                completion(nil, nil)
            }
            return
        }
        
        CommsProvider.sharedInstance.request(type: .getSmallcaseDetailData, params: ["scid":scid]) { (response, error) in
            guard let result = response else {
                return
            }
            if let smallcaseResponse = result as? [String:Any] {
                
                if let success = smallcaseResponse["success"] as? Bool {
                    if success {
                        if let smallcaseData = smallcaseResponse["data"] as? [String: Any] {
                            if SmallcaseEntity.createSmallcase(smallcaseData) {
                                if let smallcaseEntity = SmallcaseEntity.fetchSmallcase(scid) {
                                    print("DataProvider:- received \(RequestType.getSmallcaseDetailData.rawValue) response = \(result)")
                                    completion(smallcaseEntity, nil)
                                } else {
                                    print("DataProvider: could not fetch data from Core data")
                                    completion(nil, nil)
                                }
                            } else {
                                print("DataProvider: could not save data in Core data")
                                completion(nil, nil)
                            }
                        } else {
                            print("DataProvider: Received emty data in response")
                            completion(nil, nil)
                        }
                    } else if let error = smallcaseResponse["error"] as? [String] {
                        print("DataProvider: error received = \(error)")
                        completion(nil, nil)
                    }
                } else {
                    print("No success key")
                    completion(nil, nil)
                }
            } else {
                print("DataProvider: could not fetch data from API")
                completion(nil, error)
            }
        }
    }
    
    
    func getHistoricalData(for scid: String, and duration: Duration, completion: @escaping ([HistoricalEntity], Error?)->()) {
        
        CommsProvider.isUnreachable { _ in
            let arrHistoricalEntity = HistoricalEntity.fetchHistorical(for: scid, and: duration)
            completion(arrHistoricalEntity, nil)
            return
        }
        
        CommsProvider.sharedInstance.request(type: .getHistoricalData, params: ["scid":scid, "duration":duration.rawValue]) { (response, error) in
            guard let result = response else {
                return
            }
            if let historicalResponse = result as? [String:Any] {
                
                if let success = historicalResponse["success"] as? Bool {
                    if success {
                        if let historicalData = historicalResponse["data"] as? [String: Any] {
                            if HistoricalEntity.storeHistorical(historicalData, for: duration) {
                                let arrHistoricalEntity = HistoricalEntity.fetchHistorical(for: scid, and: duration)
                                print("DataProvider:- received \(RequestType.getHistoricalData.rawValue) response = \(result)")
                                completion(arrHistoricalEntity, nil)
                                return
                            } else {
                                print("DataProvider: could not save data in Core data")
                                completion([], nil)
                            }
                            
                        } else {
                            print("DataProvider: Received emty data in response")
                            completion([], nil)
                        }
                    } else if let error = historicalResponse["error"] as? [String] {
                        print("DataProvider: error received = \(error)")
                        completion([], nil)
                    }
                } else {
                    print("No success key")
                    completion([], nil)
                }
            } else {
                print("DataProvider: could not fetch data from API")
                completion([], error)
            }
            return
        }
    }
    
    
}
