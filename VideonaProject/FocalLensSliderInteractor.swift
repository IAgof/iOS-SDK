//
//  FocalLensSliderInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreAudio

class FocalLensSliderInteractor: FocalLensSliderInteractorInterface {
    //MARK : VIPER
    var delegate:FocalLensSliderInteractorDelegate?
    var audioSession:AVCaptureSession?
    
    var isManualModeEnabled = false
    
    init(presenter:FocalLensSliderPresenter){
        delegate = presenter
    }

    func setLensDistanceTo(_ value:Float){
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            try device?.lockForConfiguration()
            let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            
            if (captureDevice?.isFocusModeSupported(AVCaptureFocusMode.locked))! {
                captureDevice?.setFocusModeLockedWithLensPosition(value, completionHandler: {
                    time in
                    print("time in \(time)")
                })
            }
            
        }catch{
            return
        }
    }
}

