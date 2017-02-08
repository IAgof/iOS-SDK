//
//  Utils.swift
//  Kamarada
//
//  Created by Alejandro Arjonilla Garcia on 21/4/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

open class Utils:NSObject{
    open var thumbnailEditorListDiameter:Int {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return 80
        case .pad:
            return 120
        case .unspecified:
            return 50
        default:
            return 80
        }
    }
    
    open let udid = UIDevice.current.identifierForVendor!.uuidString

    open func getDoubleHourAndMinutes() -> Double{
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.hour, .minute], from: date)
        let hour = components.hour
        let minutes = components.minute

        return Double(hour!) + (Double(minutes!))/60;
    }
    
    open func giveMeTimeNow()->String{
        var dateString:String = ""
        let dateFormatter = DateFormatter()
        
        let date = Date()
        
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 3600) //GMT +1
        dateString = dateFormatter.string(from: date)
        
        debugPrint("La hora es : \(dateString)")
        
        return dateString
    }

    open func debugLog(_ logMessage:String){
        #if DEBUG
            print("\n \(logMessage)")
        #endif
    }
    
    open func getUDID() -> String{
        return udid
    }
    
    open func getStringByKeyFromSettings(_ key:String) -> String {
        return Bundle.main.localizedString(forKey: key,value: "",table: "Settings")
    }
    
    open func getStringByKeyFromShare(_ key:String) -> String {
        return Bundle.main.localizedString(forKey: key,value: "",table: "Share")
    }
    
    open func getStringByKeyFromIntro(_ key:String) -> String {
        return Bundle.main.localizedString(forKey: key,value: "",table: "Intro")
    }
    open func getStringByKeyFromEditor(_ key:String) -> String {
        return Bundle.main.localizedString(forKey: key,value: "",table: "EditorStrings")
    }
    open func getStringByKeyFromProjectList(_ key:String) -> String {
        return Bundle.main.localizedString(forKey: key,value: "",table: "ProjectList")
    }
    
    open func hourToString(_ time:Double) -> String {
        let mins = Int(floor(time.truncatingRemainder(dividingBy: 3600)) / 60)
        let secs = Int(floor(time.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60))
        
        let x:Double = (time.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60)
        let numberOfPlaces:Double = 4.0
        let powerOfTen:Double = pow(10.0, numberOfPlaces)
        let targetedDecimalPlaces:Double = round((x.truncatingRemainder(dividingBy: 1.0)) * powerOfTen) / powerOfTen
        
        let decimals = Int(targetedDecimalPlaces * 1000)

        return String(format:"%02d:%02d:%02d", mins, secs,decimals)
    }
    
    open func formatTimeToMinutesAndSeconds(_ time:Double) -> String {
        let mins = Int(floor(time.truncatingRemainder(dividingBy: 3600)) / 60)
        let secs = Int(floor(time.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60))
        
        return String(format:"%02d:%02d", mins, secs)
    }
    
    open func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    
    open func removeFileFromURL(_ URL:URL){
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: URL)
        }
        catch let error as NSError {
            print("Ooops! Cant remove file at \(URL) \n Something went wrong: \(error)")
        }
    }
}
