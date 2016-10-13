//
//  Media.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 20/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

public class Media: NSObject {
    /**
     * Title of the media. Should be the video name in the social network
     */
    var title:String!
    
    /**
     * The path of the media resource
     */
    var mediaPath:String!
    
    // TODO(jliarte): 14/06/16 seems to not being used. If so, maybe initialize in getter?
    //    protected File source;
    
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
    
    var duration:Double = 0.0
    
    public var audioLevel:Float = 1.0
    
    public init(title:String,
                  mediaPath:String) {
        self.title = title
        self.mediaPath = mediaPath
    }
    
    public func mediaRecordedFinished(){
        let urlAsset = NSURL(fileURLWithPath: mediaPath)
        let asset = AVAsset(URL: urlAsset)
        
        fileStartTime = 0.0
        fileStopTime = asset.duration.seconds
        trimStartTime = fileStartTime
        trimStopTime = fileStopTime
        duration = asset.duration.seconds
    }
    
    public func getTitle() -> String {
        return title!
    }
    
    public func setMediaTitle(title:String)  {
        self.title = title
    }
    
    public func getMediaPath() -> String {
        return mediaPath!
    }
    
    public func setVideonaMediaPath(path:String) {
        self.mediaPath = path
    }
    
    public func getStartTime() -> Double {
        return trimStartTime
    }
    
    public func setStartTime(time:Double) {
        self.trimStartTime = time
        
        self.duration = trimStopTime - trimStartTime
    }
    
    public func getStopTime() -> Double {
        return trimStopTime
    }
    
    public func setStopTime(time:Double) {
        self.trimStopTime = time
        
        self.duration = trimStopTime - trimStartTime
    }
    
    public func getDuration() -> Double {
        return self.duration
    }
    
    public func getFileStopTime() -> Double {
        return fileStopTime
    }
    
    public func getFileStartTime() -> Double {
        return fileStartTime
    }
    
}