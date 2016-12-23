//
//  UserData.swift
//  HackNTU_IOS_Project
//
//  Created by Yuan-Pu Hsu on 22/12/2016.
//  Copyright © 2016 Peter. All rights reserved.
//

import Foundation
class historyData
{
    var date: String?
    var coins: Double?
    var distance: Double?
    var walk: Double?
    var bicycle: Double?
    var bus: Double?
    var subway: Double?
    
    init(date: String, coins: Double, distance: Double, walk: Double, bicycle: Double, bus: Double, subway: Double) {
        self.date = date
        self.coins = coins
        self.distance = distance
        self.walk = walk
        self.bicycle = bicycle
        self.bus = bus
        self.subway = subway
    }
    
    init(dataDictionary: [String: Any]) {
        self.date = dataDictionary["Date"] as? String
        self.coins = dataDictionary["Coins"] as? Double
        self.distance = dataDictionary["Distance"] as? Double
        if let toolsDic = dataDictionary["Tools"] as? [String: Any] {
            self.walk = toolsDic["Walk"] as? Double
            self.bicycle = toolsDic["Bicycle"] as? Double
            self.bus = toolsDic["Bus"] as? Double
            self.subway = toolsDic["Subway"] as? Double
        }
        
    }
    
    static func getAllHistoryData() -> [historyData] {
        var histData = [historyData]()
        let dataFile = Bundle.main.path(forResource: "data", ofType: "plist")
        let dataFileURL = URL(fileURLWithPath: dataFile!)
        let dataLoaded = try? Data(contentsOf: dataFileURL)
        
        if let plistDictionary = parsePListFromData(dataLoaded) {
            let dataDictionaries = plistDictionary["Data"] as! [[String: Any]]
            for dataDictionnary in dataDictionaries {
                let newData = historyData(dataDictionary: dataDictionnary)
                histData.append(newData)
            }
        }
        return histData
    }
    static func parsePListFromData(_ plistData: Data?) -> [String: AnyObject]? {
        if let data = plistData {
            do {
                let plistDictionary = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as! [String: AnyObject]
                return plistDictionary
            }catch let error as NSError {
                print("Error processing plist data: \(error.localizedDescription)")
            }
        }
        return nil
    }
    /*
    static func storeAllHistoryData(allData: [historyData]) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = paths.appending("dataS.plist")
        let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: path)))
        {
            do {
                let bundle = Bundle.main.path(forResource: "dataS", ofType: "plist")
                try fileManager.copyItem(atPath: bundle!, toPath: path)
            }catch let error as NSError {
                print("Error editting plist data: \(error.localizedDescription)")
            }
            
        }
        let cocoaArray: NSArray = sortDataToArray(inputData: allData)
        if !cocoaArray.write(toFile: path, atomically: false) {
                print("File not written successfully")
        }
    }
    
    static func sortDataToArray(inputData: [historyData]) -> NSArray {
        var array: NSMutableArray = []
        for data in inputData {
            let newDic: [String:Any] = [
                "Date": data.date!,
                "Coins": data.coins!,
                "Distance": data.distance!,
                "Tools": [
                    "Walk": data.walk!,
                    "Bicycle": data.bicycle!,
                    "Bus": data.bus!,
                    "Subway": data.subway!
                    ] as [String: Double]
            ]
            array.add(newDic)
        }
        return array
    }*/
}
