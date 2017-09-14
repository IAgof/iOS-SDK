//
//  TrackModel.swift
//  testDrawingPortionsOverVideonaRangeSlider
//
//  Created by Alejandro Arjonilla Garcia on 3/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

import UIKit

public struct TrackModel {
    public var lowerValue: CGFloat
    public var width: CGFloat
    public var color: CGColor

    public init(maxValue: Float,
         lowerValue: Float,
         upperValue: Float,
         color: CGColor) {

        self.lowerValue = CGFloat(lowerValue/maxValue)

        let innerUpperValue = CGFloat(upperValue/maxValue)
        self.width = max(0, innerUpperValue - self.lowerValue)

        self.color = color
    }
}
