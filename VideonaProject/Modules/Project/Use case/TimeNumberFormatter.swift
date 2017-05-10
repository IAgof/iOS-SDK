//
//  TimeNumberFormatter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 12/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

public class TimeNumberFormatter:NumberFormatter{
    override public func string(from number: NSNumber) -> String? {
        let time = Double(number)
        let mins = Int(floor(time.truncatingRemainder(dividingBy: 3600)) / 60)
        let secs = Int(floor(time.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60))
        
        let x:Double = (time.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60)
        let numberOfPlaces:Double = 4.0
        let powerOfTen:Double = pow(10.0, numberOfPlaces)
        let targetedDecimalPlaces:Double = round((x.truncatingRemainder(dividingBy: 1.0)) * powerOfTen) / powerOfTen
        
        let decimals = Int(targetedDecimalPlaces * 1000)
        
        return String(format:"%02d:%02d,%02d", mins, secs,decimals)
        
    }
}
