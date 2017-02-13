//
//  ExpositionModesInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreAudio

class ExpositionModesInteractor: ExpositionModesInteractorInterface {
    //MARK : VIPER
    var delegate:ExpositionModesInteractorDelegate?
    var audioSession:AVCaptureSession?
    
    var isManualModeEnabled = false
    
    init(presenter:ExpositionModesPresenter){
        delegate = presenter
    }
    
    func setAutoExposureMode() {
        do{
            let captureDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
            for captureDevice in captureDevices!{
                let device = captureDevice as! AVCaptureDevice
                do {
                    try device.lockForConfiguration()
                    
                    device.exposureMode = .locked
                    
                    device.exposureMode = .continuousAutoExposure
                    
                    device.unlockForConfiguration()
                    
                }catch{
                    return
                }
            }
        }
        isManualModeEnabled = false
    }
    
    func setManualExposureMode() {
        isManualModeEnabled = true
    }
    
    func setManualExposureModeOff(){
        isManualModeEnabled = false
    }
    
    func setExpositionCenterMode() {
        isManualModeEnabled = false
        do{
            let captureDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
            for captureDevice in captureDevices!{
                let device = captureDevice as! AVCaptureDevice
                do {
                    try device.lockForConfiguration()
                    
                    device.exposureMode = .locked
                    
                    let pointOfInterest = CGPoint(x: 0.5, y: 0.5)
                    
                    //            if (device.position == AVCaptureDevicePosition.Front) {
                    //                location.x = viewFrame.width - location.x;
                    //            }
                    
                    if (device.isExposurePointOfInterestSupported && device.isExposureModeSupported(AVCaptureExposureMode.autoExpose)) {
                        device.exposurePointOfInterest = pointOfInterest
                        device.exposureMode = AVCaptureExposureMode.continuousAutoExposure
                    }
                    
                    device.unlockForConfiguration()
                    
                }catch{
                    return
                }
            }
        }
        
    }
    
    func expositionToPoint(_ tapLocation: CGPoint,
                           viewFrame: CGRect) {
        if isManualModeEnabled {
            var location:CGPoint = tapLocation
            delegate?.sendFocusPoint(location)
            do{
                let captureDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
                for captureDevice in captureDevices!{
                    let device = captureDevice as! AVCaptureDevice
                    do {
                        try device.lockForConfiguration()
                        
                        var pointOfInterest = CGPoint(x: 0.5, y: 0.5)
                        
                        if (device.position == AVCaptureDevicePosition.front) {
                            location.x = viewFrame.width - location.x;
                        }
                        
                        pointOfInterest = CGPoint(x: location.y / viewFrame.height, y: 1.0 - (location.x / viewFrame.width));
                        
                        print("Point to ExpositionModes= \n x--\(pointOfInterest.x) \ny--\(pointOfInterest.y)")
                        if (device.isExposurePointOfInterestSupported && device.isExposureModeSupported(AVCaptureExposureMode.autoExpose)) {
                            device.exposurePointOfInterest = pointOfInterest
                            device.exposureMode = AVCaptureExposureMode.autoExpose
                        }
                        
                        device.unlockForConfiguration()
                        
                    }catch{
                        return
                    }
                }
            }
        }
    }
}

