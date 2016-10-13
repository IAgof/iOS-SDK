//
//  Utils.swift
//  Kamarada
//
//  Created by Alejandro Arjonilla Garcia on 21/4/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

public class Utils{
    public static let sharedInstance = Utils()
    
    var thumbnailEditorListDiameter:Int {
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            return 80
        case .Pad:
            return 120
        case .Unspecified:
            return 50
        default:
            return 80
        }
    }
    
    let udid = UIDevice.currentDevice().identifierForVendor!.UUIDString

    public func getDoubleHourAndMinutes() -> Double{
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = components.hour
        let minutes = components.minute

        return Double(hour) + (Double(minutes))/60;
    }
    
    public func giveMeTimeNow()->String{
        var dateString:String = ""
        let dateFormatter = NSDateFormatter()
        
        let date = NSDate()
        
        dateFormatter.locale = NSLocale(localeIdentifier: "es_ES")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 3600) //GMT +1
        dateString = dateFormatter.stringFromDate(date)
        
        Utils().debugLog("La hora es : \(dateString)")
        
        return dateString
    }
    
    public func debugLog(logMessage:String){
        #if DEBUG
            print("\n \(logMessage)")
        #endif
    }
    
    public func getUDID() -> String{
        return udid
    }
    
    public func getStringByKeyFromSettings(key:String) -> String {
        return NSBundle.mainBundle().localizedStringForKey(key,value: "",table: "Settings")
    }
    
    public func getStringByKeyFromShare(key:String) -> String {
        return NSBundle.mainBundle().localizedStringForKey(key,value: "",table: "Share")
    }
    
    public func getStringByKeyFromIntro(key:String) -> String {
        return NSBundle.mainBundle().localizedStringForKey(key,value: "",table: "Intro")
    }
    public func getStringByKeyFromEditor(key:String) -> String {
        return NSBundle.mainBundle().localizedStringForKey(key,value: "",table: "Editor")
    }
    public func hourToString(time:Double) -> String {
//        let hours = Int(floor(time/3600))
        let mins = Int(floor(time % 3600) / 60)
        let secs = Int(floor(time % 3600) % 60)
        
        let x:Double = (time % 3600) % 60
        let numberOfPlaces:Double = 4.0
        let powerOfTen:Double = pow(10.0, numberOfPlaces)
        let targetedDecimalPlaces:Double = round((x % 1.0) * powerOfTen) / powerOfTen
        
        let decimals = Int(targetedDecimalPlaces * 1000)
        
//        return String(format:"%d:%02d:%02d,%02d", hours, mins, secs,decimals)
        return String(format:"%02d:%02d:%02d", mins, secs,decimals)
//        return String(format:"%02d:%02d", mins, secs)
    }
    
    public func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
}