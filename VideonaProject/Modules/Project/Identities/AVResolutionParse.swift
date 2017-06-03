//
//  AVResolutionParse.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 1/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

public struct Resolution {
    public var width:CGFloat
    public var height:CGFloat
    
    public var front:String = AVCaptureSessionPreset1280x720
    public var back:String
    
    public var size: CGSize{
        return CGSize(width: width, height: height)
    }
    
    public init(AVResolution:String){
        back = AVResolution
        
        switch AVResolution {
        case AVCaptureSessionPreset352x288:
            width = 352
            height = 288
            break
        case AVCaptureSessionPreset640x480:
            width = 640
            height = 480
            break
        case AVCaptureSessionPreset1280x720:
            width = 1280
            height = 720
            break
        case AVCaptureSessionPreset1920x1080:
            width = 1920
            height = 1080
            break
        default:
            width = 640
            height = 480
        }
    }
}

public struct CameraResolution {
    public var frontCameraResolution:String
    public var rearCameraResolution:String
    
    public init(AVResolution:String){
        
        if #available(iOS 9.0, *) {
            switch AVResolution {
            case AVCaptureSessionPreset3840x2160:
                frontCameraResolution = AVCaptureSessionPreset1280x720
                rearCameraResolution = AVCaptureSessionPreset3840x2160
                break
            case AVCaptureSessionPreset1280x720:
                frontCameraResolution = AVCaptureSessionPreset1280x720
                rearCameraResolution = AVCaptureSessionPreset1280x720
                break
            case AVCaptureSessionPreset1920x1080:
                frontCameraResolution = AVCaptureSessionPreset1280x720
                rearCameraResolution = AVCaptureSessionPreset1920x1080
                break
            default:
                frontCameraResolution = AVCaptureSessionPreset1280x720
                rearCameraResolution = AVCaptureSessionPreset1280x720
                break
            }
        } else {
            frontCameraResolution = AVCaptureSessionPreset1280x720
            rearCameraResolution = AVCaptureSessionPreset1280x720
        }
    }    
}

public class AVResolutionParse: NSObject {
    var regularResolution = Utils().getStringByKeyFromSettings("regular_resolution_name")
    var mediumResolution =  Utils().getStringByKeyFromSettings("medium_resolution_name")
    var goodResolution =  Utils().getStringByKeyFromSettings("good_resolution_name")
    
    public func resolutionsToView() -> Array<String>  {
        var resolutionsToTheTableView = Array<String>()
        
        let resolutionsCompatibles = CompatibleResolutionsInteractor().getCompatibleResolutions()
        
        for resolution in resolutionsCompatibles{
            resolutionsToTheTableView.append(self.parseResolutionToView(resolution))
        }
        
        return resolutionsToTheTableView
    }
    
    public func parseResolutionToView(_ resolution:String) -> String {
        if #available(iOS 9.0, *) {
            switch resolution {
            case AVCaptureSessionPreset3840x2160:
                return goodResolution
            case AVCaptureSessionPreset1920x1080:
                return mediumResolution
            case AVCaptureSessionPreset1280x720:
                return regularResolution
            default:
                return "Media (720)"
            }
        } else {
            return mediumResolution
        }
    }
    
    public func parseResolutionsToInteractor(_ textResolution:String) -> String {
        switch textResolution {
        case goodResolution:
            if #available(iOS 9.0, *) {
                return AVCaptureSessionPreset3840x2160
            } else {
                return AVCaptureSessionPreset1920x1080
            }
        case mediumResolution :
            return AVCaptureSessionPreset1920x1080
        case regularResolution :
            return AVCaptureSessionPreset1280x720
        default:
            return AVCaptureSessionPreset1280x720
        }
    }
}
