//
//  TrimInteractorInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 2/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject

public protocol TrimInteractorInterface {    
    func setParametersOnVideoSelectedOnProjectList(_ startTime:Float,
                                                   stopTime:Float)
    func setParametersOnVideoSelected(_ startTime:Float,
                                      stopTime:Float)
    func setUpComposition(_ completion:(VideoComposition)->Void)
    func setVideoPosition(_ position:Int)
    
    func getVideoParams()
}

public protocol TrimInteractorDelegate {
    func setLowerValue(_ value:Float)
    func setUpperValue(_ value:Float)
    func setMaximumValue(_ value:Float)
    func updateParamsFinished()
}
