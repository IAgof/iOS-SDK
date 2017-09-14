//
//  WhiteBalanceConstants.swift
//  WhiteBalance
//
//  Created by Alejandro Arjonilla Garcia on 9/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

enum WhiteBalanceGain: Int {
    case auto = -1
    case cloudy = 7000
    case daylight = 5500
    case flash = 5000
    case fluorescent = 4500
    case tungsten = 3000
}
