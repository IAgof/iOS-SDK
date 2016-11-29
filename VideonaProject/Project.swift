//
//  Project.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 20/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

open class Project: NSObject {
    
    /**
     * There could be just one project open at a time. So this converts Project in a Singleton.
     */
    //    static let sharedInstance = Project()

    //    private final String TAG = getClass().getCanonicalName()
    static var VIDEONA_PATH = ""
    
    /**
     * Project name. Also it will be the name of the exported video
     */
    fileprivate var title:String = ""
    /**
     * The folder where de temp files of the project are stored
     */
    fileprivate var projectPath:String = ""

    /**
     * Path where exported videos are
     */
    fileprivate var exportedPath:String = ""
    
    /**
     * List of Videos Recorded
     */
    fileprivate var videoList = Array<Video>()
    
    /**
     * Project profile. Defines some limitations and characteristic of the project based on user
     * subscription.
     */
    fileprivate  var profile = Profile()
    
    /**
     * Project duration. The duration of the project in milliseconds.
     */
    fileprivate var duration:Double = 0.0
    
    /**
     * Music to add to export video ( may be nil)
     */
    fileprivate var music = Music(title: "",
                              author: "",
                              iconResourceId: "",
                              musicResourceId: "",
                              musicSelectedResourceId: "")
    open var isMusicSet:Bool = false
    
    open var voiceOver = Audio(title: "", mediaPath: "")
    
    open var isVoiceOverSet = false
    
    open var projectOutputAudioLevel:Float = 1.0
    
    open var transitionTime:Double = 1
    
    override public init() {
        self.title = "testTitle\(Utils().giveMeTimeNow())"
        self.projectPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        self.profile = Profile(resolution: "", videoQuality: "", maxDuration: 0, type: Profile.ProfileType.free)
        self.duration = 0
        
        videoList = Array<Video>()
    }
    
    public init(title:String, rootPath:String, profile:Profile) {
        self.title = title
        self.projectPath = rootPath
        self.profile = profile
        videoList = Array<Video>()
        
    }

    // getters & setters
    open func getTitle() ->String{
        return self.title
    }
    
    open func setTitle(_ title:String) {
        self.title = title
    }
    
    open func getProjectPath() -> String{
        return projectPath
    }
    
    open func setProjectPath(_ projectPath:String) {
        self.projectPath = projectPath
    }
    
    open func getProfile() -> Profile{
        return self.profile
    }
    
    open func setProfile(_ profile:Profile) {
        self.profile = profile
    }
    
    open func getDuration()->Double {
        duration = 0
        for video in videoList{
            duration += video.getDuration()
        }
        return duration
    }
    
    open func setDuration(_ duration:Double) {
        self.duration = duration
    }
    
    open func clear() {
        self.title = "testTitle\(Utils().giveMeTimeNow())"
        self.projectPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        self.profile = Profile(resolution: "", videoQuality: "", maxDuration: 0, type: Profile.ProfileType.free)
        self.duration = 0
        
        videoList = Array<Video>()
    }
    
    open func numberOfClips() -> Int{

        return videoList.count
    }
    
    open func setVideoList(_ list:Array<Video>){
        self.videoList = list
    }
    
    open func getVideoList() -> Array<Video> {
        return videoList
    }
    
    fileprivate func getNewProjectExportPath() -> String {
        return "\(projectPath)/videoExported\(Utils().giveMeTimeNow()).m4v"
    }
    
    open func setExportedPath() {
        self.exportedPath = self.getNewProjectExportPath()
    }
    
    open func getExportedPath() -> String {
        return self.exportedPath
    }
    
    open func setMusic(_ music:Music){
        isMusicSet = (music.getTitle() != "")
        
        self.music = music
    }
    
    open func getMusic() ->Music{
        return music
    }
}
