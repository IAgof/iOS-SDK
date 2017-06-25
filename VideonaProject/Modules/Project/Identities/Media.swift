//
//  Media.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 20/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

open class Media: NSObject {
    /**
     * Title of the media. Should be the video name in the social network
     */
    var title:String = ""
    
    /**
     * The path of the media resource
     */
    var mediaPath:String = ""
 
    /**
     * The start time of the media resource within the file it represents.
     */
    var fileStartTime:Double = 0.0
    /**
     * The stop time of the media resource within the file it represents.
     */
    var fileStopTime:Double = 0.0
    
    
    var trimStartTime:Double = 0.0
    
    var trimStopTime:Double = 0.0
        
    open var audioLevel:Float = 1.0
    public var  uuid = UUID().uuidString

    public init(title:String,
                  mediaPath:String) {
        self.title = title
        self.mediaPath = mediaPath
    }
        
    open func getTitle() -> String {
        return title
    }
    
    open func setMediaTitle(_ title:String)  {
        self.title = title
    }
    
    open func getMediaPath() -> String {
        return mediaPath
    }
    
    open func setVideonaMediaPath(_ path:String) {
        self.mediaPath = path
    }
    
    open func getStartTime() -> Double {
        return trimStartTime
    }
    
    open func setStartTime(_ time:Double) {
        self.trimStartTime = time
    }
    
    open func getStopTime() -> Double {
        return trimStopTime
    }
    
    open func setStopTime(_ time:Double) {
        self.trimStopTime = time
    }
    
    open func getDuration() -> Double {
        return  trimStopTime - trimStartTime
    }
    
    open func getFileStopTime() -> Double {
        return fileStopTime
    }

    open func getFileStartTime() -> Double {
        return fileStartTime
    }
    
}
