//
//  ZoomSliderInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreAudio

class ZoomSliderInteractor: ZoomSliderInteractorInterface {
    //MARK : VIPER
    var delegate: ZoomSliderInteractorDelegate?
    var audioSession: AVCaptureSession?

    var maxZoomFactor = CGFloat(10)

    init(presenter: ZoomSliderPresenter) {
        delegate = presenter
    }

    func setZoomTo(_ scale: CGFloat,
                   velocity: CGFloat) {
        let captureDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for captureDevice in captureDevices! {
            let device = captureDevice as! AVCaptureDevice
            var vZoomFactor = scale
            let pinchVelocityDividerFactor: Float = 50//To change velocity of zoom

            var error: NSError!
            do {
                try device.lockForConfiguration()
                defer {device.unlockForConfiguration()}

                if (vZoomFactor < device.activeFormat.videoMaxZoomFactor) {
                    let desiredZoomFactor = device.videoZoomFactor + CGFloat.init( atan2f(Float(velocity), pinchVelocityDividerFactor))
                    if maxZoomFactor > device.activeFormat.videoMaxZoomFactor {
                        maxZoomFactor = device.activeFormat.videoMaxZoomFactor
                    }
                    // Check if desiredZoomFactor fits required range from 1.0 to activeFormat.videoMaxZoomFactor
                    let videoFutureFactor = min(desiredZoomFactor, maxZoomFactor)
                    device.videoZoomFactor = max(1.0, videoFutureFactor)
                    //                print("Desired zoom = \(videoFutureFactor)")

                    delegate?.zoomPinchedValueUpdate(Float(videoFutureFactor))
                } else {
                    NSLog("Unable to set videoZoom: (max %f, asked %f)", device.activeFormat.videoMaxZoomFactor, vZoomFactor)
                }
            } catch error as NSError {
                NSLog("Unable to set videoZoom: %@", error.localizedDescription)
            } catch _ {

            }
        }
    }

    func setZoomTo(_ value: Float) {
        let captureDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for captureDevice in captureDevices! {
            let device = captureDevice as! AVCaptureDevice
            let maxZoom = device.activeFormat.videoMaxZoomFactor

            let desiredZoomFactor = CGFloat(value)
            if maxZoomFactor > device.activeFormat.videoMaxZoomFactor {
                maxZoomFactor = device.activeFormat.videoMaxZoomFactor
            }
            var error: NSError!
            do {
                try device.lockForConfiguration()
                defer {device.unlockForConfiguration()}

                // Check if desiredZoomFactor fits required range from 1.0 to activeFormat.videoMaxZoomFactor
                device.videoZoomFactor = max(1.0, min(desiredZoomFactor, maxZoomFactor))
                //            print("Desired zoom = \(desiredZoomFactor)")
            } catch error as NSError {
                NSLog("Unable to set videoZoom: %@", error.localizedDescription)
            } catch _ {

            }
        }
    }
}
