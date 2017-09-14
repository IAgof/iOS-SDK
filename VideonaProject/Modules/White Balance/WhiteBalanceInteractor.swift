//
//  WhiteBalanceInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class WhiteBalanceInteractor: WhiteBalanceInteractorInterface {
    //MARK : VIPER
    var delegate: WhiteBalanceInteractorDelegate?

    init(presenter: WhiteBalancePresenter) {
        delegate = presenter
    }

    var WBValue: Int = -1 {
        didSet {
            if WBValue == WhiteBalanceGain.auto.rawValue {
                setAutoWB()
            } else {
                updateWB(Float(WBValue))
            }
        }
    }

    func setWBToDevice(_ value: WhiteBalanceGain) {
        WBValue = value.rawValue
    }

    func updateWB(_ wbValue: Float) {
        do {
            let captureDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
            for captureDevice in captureDevices! {
                let device = captureDevice as! AVCaptureDevice
                do {
                    try device.lockForConfiguration()

                   let tempAndTint = device.deviceWhiteBalanceGains(for: AVCaptureWhiteBalanceTemperatureAndTintValues.init(temperature: wbValue, tint: 0))

                    device.setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains(tempAndTint, completionHandler: {
                        time in
                        print("Set temperature completion time: \n \(time) ")
                    })

                    device.unlockForConfiguration()

                } catch {
                    return
                }
            }
        }
    }

    func setAutoWB() {
        do {
            let captureDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
            for captureDevice in captureDevices! {
                let device = captureDevice as! AVCaptureDevice
                do {
                    try device.lockForConfiguration()

                    device.whiteBalanceMode = .continuousAutoWhiteBalance

                    device.unlockForConfiguration()
                } catch {
                    return
                }
            }
        }
    }
}
