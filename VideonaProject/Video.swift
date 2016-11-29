//
//  Video.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 21/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

open class Video: Media {
    
    open var videoURL:URL = URL(fileURLWithPath: "")
    fileprivate var isSplit:Bool!
    fileprivate var position:Int!
    open var textToVideo:String = ""
    open var textPositionToVideo:Int = 0
    open var originAudioLevel:Float = 1
    open var secondAudioLevel:Float = 0
    public let  uuid = UUID().uuidString

    override public init(title: String, mediaPath: String) {
        super.init(title: title, mediaPath: mediaPath)
        
        isSplit = false
    }
    
    open func copyWithZone(_ zone: NSZone?) -> AnyObject {
        let copy = Video(title: title,
                         mediaPath: mediaPath)
        copy.setIsSplit(isSplit)
        copy.setPosition(position)
        copy.fileStopTime = fileStopTime
        copy.setStopTime(trimStopTime)
        copy.setStartTime(trimStartTime)
        copy.duration = duration
        copy.textToVideo = textToVideo
        copy.textPositionToVideo = textPositionToVideo
        copy.originAudioLevel = originAudioLevel
        copy.secondAudioLevel = secondAudioLevel
        copy.videoURL = videoURL
        
        return copy
    }
    
    open func mediaRecordedFinished(){
        let asset = AVAsset(url: videoURL)
        
        fileStartTime = 0.0
        fileStopTime = asset.duration.seconds
        trimStartTime = fileStartTime
        trimStopTime = fileStopTime
        duration = asset.duration.seconds
    }
    
    open func setDefaultVideoParameters(){
        let asset = AVAsset(url: videoURL)
        
        fileStartTime = 0.0
        fileStopTime = asset.duration.seconds
        duration = asset.duration.seconds
   }
    
    open func getIsSplit() -> Bool {
        return isSplit
    }
    
    open func setIsSplit(_ state:Bool){
        self.isSplit = state
    }
    
    open func getPosition()->Int{
        return self.position
    }
    
    open func setPosition(_ position:Int){
        self.position = position
    }
}
