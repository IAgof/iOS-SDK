//
//  Video.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 21/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

public class Video: Media {
    
    private var isSplit:Bool!
    private var position:Int!
    public var textToVideo:String = ""
    public var textPositionToVideo:Int = 0
    public var originAudioLevel:Float = 1
    public var secondAudioLevel:Float = 0
    
    override public init(title: String, mediaPath: String) {
        super.init(title: title, mediaPath: mediaPath)
        
        isSplit = false
    }
    
    public func copyWithZone(zone: NSZone) -> AnyObject {
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
        
        return copy
    }
    
    public func getIsSplit() -> Bool {
        return isSplit
    }
    
    public func setIsSplit(state:Bool){
        self.isSplit = state
    }
    
    public func getPosition()->Int{
        return self.position
    }
    
    public func setPosition(position:Int){
        self.position = position
    }
}