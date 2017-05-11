//
//  Profile.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 20/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

open class Profile: NSObject {
    
    fileprivate var resolution:String

    fileprivate var videoQuality:String
    
    public var frameRate:Int = 30
    
    init(resolution:String,
         videoQuality:String,
         maxDuration:Double) {
        self.resolution = resolution
        self.videoQuality = videoQuality
    }
    
    public init(resolution:String,
                videoQuality:String,
                frameRate:Int){
        self.resolution = resolution
        self.videoQuality = videoQuality
        self.frameRate = frameRate
    }
    
    override init(){
        self.resolution = AVCaptureSessionPreset1280x720
        self.videoQuality = AVQualityParse().parseQualityToView(resolution: AVAssetExportPresetHighestQuality)
    }
    
    //getter and setter.
    open func getResolution() -> String {
        return self.resolution
    }
    
    open func setResolution(_ resolution:String) {
            self.resolution = resolution
    }
    
    //getter and setter video quality
    open func getQuality() -> String {
        return self.videoQuality
    }
    
    open func setQuality(_ quality:String) {
        self.videoQuality = quality
    }
}
