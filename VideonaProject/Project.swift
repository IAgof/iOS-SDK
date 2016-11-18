//
//  Project.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 20/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

public class Project: NSObject {
    
    /**
     * There could be just one project open at a time. So this converts Project in a Singleton.
     */
    //    static let sharedInstance = Project()

    //    private final String TAG = getClass().getCanonicalName()
    static var VIDEONA_PATH = ""
    
    /**
     * Project name. Also it will be the name of the exported video
     */
    private var title:String = ""
    /**
     * The folder where de temp files of the project are stored
     */
    private var projectPath:String = ""

    /**
     * Path where exported videos are
     */
    private var exportedPath:String = ""
    
    /**
     * List of Videos Recorded
     */
    private var videoList = Array<Video>()
    
    /**
     * Project profile. Defines some limitations and characteristic of the project based on user
     * subscription.
     */
    private  var profile = Profile()
    
    /**
     * Project duration. The duration of the project in milliseconds.
     */
    private var duration:Double = 0.0
    
    /**
     * Music to add to export video ( may be nil)
     */
    private var music = Music(title: "",
                              author: "",
                              iconResourceId: "",
                              musicResourceId: "",
                              musicSelectedResourceId: "")
    public var isMusicSet:Bool = false
    
    public var voiceOver = Audio(title: "", mediaPath: "")
    
    public var isVoiceOverSet = false
    
    public var projectOutputAudioLevel:Float = 1.0
    
    public var transitionTime:Double = 1
    
    override public init() {
        self.title = "testTitle\(Utils().giveMeTimeNow())"
        self.projectPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        self.profile = Profile(resolution: "", videoQuality: "", maxDuration: 0, type: Profile.ProfileType.free)
        self.duration = 0
        
        videoList = Array<Video>()
    }
    
    // getters & setters
    public func getTitle() ->String{
        return self.title
    }
    
    public func setTitle(title:String) {
        self.title = title
    }
    
    public func getProjectPath() -> String{
        return projectPath
    }
    
    public func setProjectPath(projectPath:String) {
        self.projectPath = projectPath
    }
    
    public func getProfile() -> Profile{
        return self.profile
    }
    
    public func setProfile(profile:Profile) {
        self.profile = profile
    }
    
    public func getDuration()->Double {
        duration = 0
        for video in videoList{
            duration += video.getDuration()
        }
        return duration
    }
    
    public func setDuration(duration:Double) {
        self.duration = duration
    }
    
    public func clear() {
        self.title = "testTitle\(Utils().giveMeTimeNow())"
        self.projectPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        self.profile = Profile(resolution: "", videoQuality: "", maxDuration: 0, type: Profile.ProfileType.free)
        self.duration = 0
        
        videoList = Array<Video>()
    }
    
    public func numberOfClips() -> Int{

        return videoList.count
    }
    
    public func setVideoList(list:Array<Video>){
        self.videoList = list
    }
    
    public func getVideoList() -> Array<Video> {
        return videoList
    }
    
    private func getNewProjectExportPath() -> String {
        return "\(projectPath)/videoExported\(Utils.sharedInstance.giveMeTimeNow()).m4v"
    }
    
    public func setExportedPath() {
        self.exportedPath = self.getNewProjectExportPath()
    }
    
    public func getExportedPath() -> String {
        return self.exportedPath
    }
    
    public func setMusic(music:Music){
        self.music = music
    }
    
    public func getMusic() ->Music{
        return music
    }
}