//
//  VideoOutputParameters.swift
//  VideonaProject
//
//  Created by Alejandro Arjonilla Garcia on 14/2/17.
//  Copyright © 2017 videona. All rights reserved.
//

import Foundation

public struct VideoOutputParameters {
    public var brightness: NSNumber
    public var contrast: NSNumber
    public var saturation: NSNumber
    public var exposure: NSNumber

    public init() {
        brightness = 0
        contrast = 1
        saturation = 1
        exposure = 0
    }
}
