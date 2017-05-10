//
//  ExposureInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ExposureInteractor: ExposureInteractorInterface {
    //MARK : VIPER
    var delegate:ExposureInteractorDelegate?
    
    init(presenter:ExposurePresenter){
        delegate = presenter
    }
    
    func setExposureToDevice(_ value: Float) {
        updateExposure(value)
    }
    
    func updateExposure(_ exposureValue : Float) {
        do{
            let captureDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
            for captureDevice in captureDevices!{
                let device = captureDevice as! AVCaptureDevice
                do {
                    try device.lockForConfiguration()
                
                    device.exposureMode = .locked
                    
                    device.setExposureTargetBias(exposureValue, completionHandler: {
                        time in
                        print("set exposure time:\n\(time)")
                    })
                    
                    device.unlockForConfiguration()
                    
                }catch{
                    return
                }
            }
        }
    }
    
}
