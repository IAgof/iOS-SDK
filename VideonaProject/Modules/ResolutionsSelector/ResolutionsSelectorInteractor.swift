//
//  ResolutionsSelectorInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreAudio

class ResolutionsSelectorInteractor: ResolutionsSelectorInteractorInterface {
    //MARK : VIPER
    var delegate: ResolutionsSelectorInteractorDelegate?

    var ressList: [ResolutionViewModel] = []

    init(presenter: ResolutionsSelectorPresenter) {
        delegate = presenter
    }

    func getResolutions() {
        let list = cameraResolutions()

        var resListString: [String] = []

        for resolution in list {
            resListString.append(resolution.title!)
        }

        delegate?.setResolutionsTitle(resListString)

        ressList = list
    }

    func setResolutionToDevice(_ resolutionPositionActive: Int) {
        if ressList.indices.contains(resolutionPositionActive), let resolutionToDevice = ressList[resolutionPositionActive].avFrameworkSet {
            delegate?.retrieveAVResolutionPresset(resolutionToDevice)
        }
    }

    func findInitResolutionInList(_ resolution: String) {
        var positionInList = 0
        for listResolution in ressList {
            if listResolution.avFrameworkSet == resolution {
                setResolutionToDevice(positionInList)
                delegate?.setActiveResolution(positionInList)
            }
            positionInList += 1
        }
    }

    func cameraResolutions() -> [ResolutionViewModel] {
        let deviceModel = UIDevice.current.modelName
        var resolutionsList: [ResolutionViewModel] = []

//        deviceModel == ""

        // iPhone 4S
        if (deviceModel == "iPhone 4s") {
            resolutionsList.append(ResolutionViewModel(title: "640x480", avFrameworkSet: AVCaptureSessionPreset640x480))
            resolutionsList.append(ResolutionViewModel(title: "480x360", avFrameworkSet: AVCaptureSessionPresetMedium))

        }
            // iPhone 5/5C/5S/6/6+/iPod 6
        else if (deviceModel == "iPhone 5"
            || deviceModel == "iPhone 5c"
            || deviceModel == "iPhone 5s"
            || deviceModel == "iPhone7,2"
            || deviceModel == "iPhone SE") {

            if #available(iOS 9.0, *) {
                resolutionsList.append(ResolutionViewModel(title: "3840x2160", avFrameworkSet: AVCaptureSessionPreset3840x2160))
            } else {
                // Fallback on earlier versions
            }

            resolutionsList.append(ResolutionViewModel(title: "1920x1080", avFrameworkSet: AVCaptureSessionPreset1920x1080))

            resolutionsList.append(ResolutionViewModel(title: "1280x720", avFrameworkSet: AVCaptureSessionPreset1280x720))

//            resolutionsList.append(ResolutionViewModel(title: "640x480", avFrameworkSet: AVCaptureSessionPreset640x480))
        }
            // iPhone 6S/6S+
        else if (deviceModel == "iPhone 6s"
            || deviceModel == "iPhone 6s Plus") {
            if #available(iOS 9.0, *) {
                resolutionsList.append(ResolutionViewModel(title: "3840x2160", avFrameworkSet: AVCaptureSessionPreset3840x2160))
            } else {
                // Fallback on earlier versions
            }

            resolutionsList.append(ResolutionViewModel(title: "1920x1080", avFrameworkSet: AVCaptureSessionPreset1920x1080))

            resolutionsList.append(ResolutionViewModel(title: "1280x720", avFrameworkSet: AVCaptureSessionPreset1280x720))

//            resolutionsList.append(ResolutionViewModel(title: "640x480", avFrameworkSet: AVCaptureSessionPreset640x480))

//            let lFrontCam = "1280x960,1280x720,640x480,480x360,192x144";
//            let lBackCam = "4032x3024,1920x1080,1280x720,640x480,480x360,192x144";

        }
            // iPad 2
        else if (deviceModel == "iPad 2"
            || deviceModel == "iPod Touch 6"
            || deviceModel == "iPhone 6"
            || deviceModel == "iPhone 6 Plus") {

            resolutionsList.append(ResolutionViewModel(title: "1920x1080", avFrameworkSet: AVCaptureSessionPreset1920x1080))

            resolutionsList.append(ResolutionViewModel(title: "1280x720", avFrameworkSet: AVCaptureSessionPreset1280x720))

//            resolutionsList.append(ResolutionViewModel(title: "640x480", avFrameworkSet: AVCaptureSessionPreset640x480))
        }
            // iPad 3
        else if (deviceModel == "iPad 3") {

            resolutionsList.append(ResolutionViewModel(title: "1920x1080", avFrameworkSet: AVCaptureSessionPreset1920x1080))

            resolutionsList.append(ResolutionViewModel(title: "1280x720", avFrameworkSet: AVCaptureSessionPreset1280x720))

//            resolutionsList.append(ResolutionViewModel(title: "640x480", avFrameworkSet: AVCaptureSessionPreset640x480))

//            let lFrontCam = "640x480,480x360,192x144";
//            let lBackCam = "2592x1936,1920x1080,1280x720,640x480,480x360,192x144";

        }

            // iPad 4/Air/Mini/Mini 2/Mini 3/iPod 5G
        else if (deviceModel == "iPad 4"
            || deviceModel == "iPad Air"
            || deviceModel == "iPad Mini 2"
            || deviceModel == "iPad Mini 3"
            || deviceModel == "iPad Mini 4") {

            resolutionsList.append(ResolutionViewModel(title: "1920x1080", avFrameworkSet: AVCaptureSessionPreset1920x1080))

            resolutionsList.append(ResolutionViewModel(title: "1280x720", avFrameworkSet: AVCaptureSessionPreset1280x720))

//            resolutionsList.append(ResolutionViewModel(title: "640x480", avFrameworkSet: AVCaptureSessionPreset640x480))

//            let lFrontCam = "1280x960,1280x720,640x480,480x360,192x144";
//            let lBackCam = "2592x1936,1920x1080,1280x720,640x480,480x360,192x144";

        }
            // iPad Air 2/Mini 4/Pro
        else if (deviceModel == "iPad Pro") {

            resolutionsList.append(ResolutionViewModel(title: "1920x1080", avFrameworkSet: AVCaptureSessionPreset1920x1080))

            resolutionsList.append(ResolutionViewModel(title: "1280x720", avFrameworkSet: AVCaptureSessionPreset1280x720))

//            resolutionsList.append(ResolutionViewModel(title: "640x480", avFrameworkSet: AVCaptureSessionPreset640x480))

//            let lFrontCam = "1280x960,1280x720,640x480,480x360,192x144";
//            let lBackCam = "3264x2448,1920x1080,1280x720,640x480,480x360,192x144";

        }

        return resolutionsList
    }
}

public extension UIDevice {

    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }

}
