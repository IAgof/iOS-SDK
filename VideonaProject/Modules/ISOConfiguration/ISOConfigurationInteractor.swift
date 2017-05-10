//
//  ISOConfigurationInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ISOConfigurationInteractor: ISOConfigurationInteractorInterface {
    //MARK : VIPER
    var delegate:ISOConfigurationInteractorDelegate?
    
    init(presenter:ISOConfigurationPresenter){
        delegate = presenter
    }
    
    var ISOValue:Int = -1{
        didSet{
            if ISOValue == -1 {
                setAutoISO()
            }else{
                updateISO(Float(ISOValue))
            }
        }
    }
    
    func setISOToDevice(_ value: Int) {
        ISOValue = value
    }
    
    func updateISO(_ isoValue : Float) {
        do{
            let captureDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
            for captureDevice in captureDevices!{
                let device = captureDevice as! AVCaptureDevice
                do {
                    try device.lockForConfiguration()
                    
                    if (isoValue > device.activeFormat.maxISO){
                        device.setExposureModeCustomWithDuration(AVCaptureExposureDurationCurrent, iso: device.activeFormat.maxISO, completionHandler: { (time) -> Void in
                            //
                        })
                    }else{
                        device.setExposureModeCustomWithDuration(AVCaptureExposureDurationCurrent, iso: isoValue, completionHandler: { (time) -> Void in
                            //
                        })
                    }
                    device.unlockForConfiguration()
                    
                }catch{
                    return
                }
            }
        }
    }
    
    func setAutoISO() {
        let captureDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for captureDevice in captureDevices!{
            let device = captureDevice as! AVCaptureDevice
            do {
                try device.lockForConfiguration()
                
                device.exposureMode = .autoExpose
                
                device.unlockForConfiguration()
                
            }catch{
                return
            }
        }
    }
}
