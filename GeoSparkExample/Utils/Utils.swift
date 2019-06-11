//
//  Utils.swift
//  GeoSparkExample
//
//  Created by GeoSpark Mac #1 on 31/10/18.
//  Copyright © 2018 Geospark Inc. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    static func currentTimestamp() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        return dateFormatter.string(from: date)
    }
    
    static func currentTimestampWithHours() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        return dateFormatter.string(from: date)
    }

    static func saveLocationToLocal(_ latitude : Double, longitude : Double) {
        let dataDictionary = ["latitude" : latitude, "longitude" : longitude,"timeStamp" : Utils.currentTimestampWithHours()] as [String : Any]
        print("saveLocationToLocal",dataDictionary)
        var dataArray = UserDefaults.standard.array(forKey: "GeoSparkKeyForLatLongInfo")
        if let _ = dataArray {
            dataArray?.append(dataDictionary)
        }else{
            dataArray = [dataDictionary]
        }
        UserDefaults.standard.set(dataArray, forKey: "GeoSparkKeyForLatLongInfo")
        UserDefaults.standard.synchronize()
    }

    static func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key != "DeviceToken"{
                defaults.removeObject(forKey: key)
            }
        }
    }

    static func saveLogs(_ dicts:Dictionary<String,Any>) {
        
        for dict in dicts.enumerated() {
            let dictValue = dict.element
            let dictVal = dictValue.value as? String
            if dictVal?.isEmpty == false {
                let dataDictionary = dicts
                var dataArray = UserDefaults.standard.array(forKey: "GeoSparkKeyForLogs")
                if let _ = dataArray {
                    dataArray?.append(dataDictionary)
                }else{
                    dataArray = [dataDictionary]
                }
                UserDefaults.standard.set(dataArray, forKey: "GeoSparkKeyForLogs")
                UserDefaults.standard.synchronize()
                
            }
        }
        
    }

}
extension String {
    
    func UTCToLocal() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd MMM yyyy, hh:mm"
        
        return dateFormatter.string(from: dt ?? Date())
    }
}
