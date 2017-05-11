//
//  ExpositionModesInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol ExpositionModesInteractorInterface{
    func setAutoExposureMode()
    func setManualExposureMode()
    func setManualExposureModeOff()
    
    func setExpositionCenterMode()
    func expositionToPoint(_ tapLocation:CGPoint,
                      viewFrame:CGRect)
}

protocol ExpositionModesInteractorDelegate{
    func sendFocusPoint(_ point: CGPoint)
}
