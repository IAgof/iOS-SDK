//
//  FocusInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreAudio

class FocusInteractor: FocusInteractorInterface {
    //MARK : VIPER
    var delegate:FocusInteractorDelegate?
    var audioSession:AVCaptureSession?
    
    var isManualModeEnabled = false
    
    init(presenter:FocusPresenter){
        delegate = presenter
    }
    
    func setAutoFocusMode() {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            try device?.lockForConfiguration()
            let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            captureDevice?.focusMode = .continuousAutoFocus
            
            device?.unlockForConfiguration()
            
        }catch{
            return
        }
        isManualModeEnabled = false
    }
    
    func setManualFocusMode() {
        isManualModeEnabled = true
    }
    
    func setManualFocusModeOff() {
        isManualModeEnabled = false
    }
    
    func focusToPoint(_ tapLocation:CGPoint,
                      viewFrame:CGRect){
        if isManualModeEnabled {
            var location:CGPoint = tapLocation
            delegate?.sendFocusPoint(location)
            let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            do {
                try device?.lockForConfiguration()                
                
                var pointOfInterest = CGPoint(x: 0.5, y: 0.5)
                
                if (device?.position == AVCaptureDevicePosition.front) {
                    location.x = viewFrame.width - location.x;
                }
                
                pointOfInterest = CGPoint(x: location.y / viewFrame.height, y: 1.0 - (location.x / viewFrame.width));
                
                print("Point to focus= \n x--\(pointOfInterest.x) \ny--\(pointOfInterest.y)")
                if ((device?.isFocusPointOfInterestSupported)! && (device?.isFocusModeSupported(AVCaptureFocusMode.autoFocus))!) {
                    device?.focusPointOfInterest = pointOfInterest
                    device?.focusMode = AVCaptureFocusMode.autoFocus
                }
                device?.unlockForConfiguration()
                
            }catch{
                return
            }
        }
    }
}

