//
//  SplitInteractorInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 4/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject

public protocol SplitInteractorInterface {
    func setVideoPosition(_ position:Int)
    func getVideoParams()
    func setUpComposition(_ completion:(VideoComposition)->Void)
    func setSplitVideosToProject(_ splitTime:Double)
}

public protocol SplitInteractorDelegate {
    func settSplitValue(_ value:Float)
    func setMaximumValue(_ value:Float)
}
