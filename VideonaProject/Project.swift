//
//  Project.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 20/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

open class Project: NSObject {
    
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
    fileprivate var exportedPath:String?{
        didSet{
            exportDate = NSDate()
        }
    }
    
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
    
    open var voiceOver:[Audio] = []
    
    open var isVoiceOverSet :Bool{
        if voiceOver.count != 0{
            return true
        }else{
            return false
        }
    }
    
    open var projectOutputAudioLevel:Float = 1.0
    
    open var transitionTime:Double = 1
    
    public var  uuid = UUID().uuidString

    public var modificationDate:NSDate?
    
    public var exportDate:NSDate?
    
    public var videoOutputParameters:VideoOutputParameters = VideoOutputParameters()

    public var videoFilter:CIFilter?
    
    public var transitionColor = CIColor(red: 255, green: 255, blue: 255)
//    public var transitionColor = CIColor(red: 0, green: 0, blue: 0)
    
    override public init() {
        super.init()
        self.title = ""
        self.projectPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        self.profile = Profile()
        self.duration = 0

        videoList = Array<Video>()
        modificationDate = NSDate()
        
        self.title = setUpTitle()
    }
    
    public init(title:String, rootPath:String, profile:Profile) {
        self.title = title
        self.projectPath = rootPath
        self.profile = profile
      
        videoList = Array<Video>()
        modificationDate = NSDate()
    }
    
    open func copyWithZone(_ zone: NSZone?) -> AnyObject {
        let copy = Project(title: title,
                           rootPath: projectPath,
                           profile: profile)
        
        copy.uuid = UUID().uuidString
        copy.videoList = videoList
        copy.duration = duration
        copy.music = music
        copy.isMusicSet = isMusicSet
        copy.voiceOver = voiceOver
        copy.projectOutputAudioLevel = projectOutputAudioLevel
        copy.transitionTime = transitionTime
        copy.modificationDate = modificationDate
        copy.exportDate = exportDate
        
        return copy
    }
    
    public func reloadProjectWith(project:Project){
        self.title = project.title
        self.projectPath = project.projectPath
        self.profile = project.profile
        self.duration = project.duration
        voiceOver = project.voiceOver
        projectOutputAudioLevel = project.projectOutputAudioLevel
        music = project.music
        isMusicSet = project.isMusicSet
//        isVoiceOverSet = project.isVoiceOverSet
        transitionTime = project.transitionTime
        
        videoList = project.videoList
        exportedPath = project.exportedPath
        
        videoOutputParameters = project.videoOutputParameters
        videoFilter = project.videoFilter
        
        self.uuid = project.uuid
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
        self.title = setUpTitle()
        self.projectPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        self.profile = Profile()
        self.duration = 0
        self.uuid = UUID().uuidString
        updateModificationDate()
        
        videoList = Array<Video>()
        isMusicSet = false
        projectOutputAudioLevel = 1
        voiceOver = Array<Audio>()
        
        music = Music(title: "",
                      author: "",
                      iconResourceId: "",
                      musicResourceId: "",
                      musicSelectedResourceId: "")
        
        videoOutputParameters = VideoOutputParameters()
        videoFilter = nil
        exportedPath = nil
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
    
    open func setExportedPath(path:String?) {
        self.exportedPath = path
    }
    
    open func getExportedPath() -> String? {
        return self.exportedPath
    }
    
    open func setMusic(_ music:Music){
        isMusicSet = (music.getTitle() != "")
        
        self.music = music
    }
    
    open func getMusic() ->Music{
        return music
    }
    
    public func updateModificationDate(){
        modificationDate = NSDate()
    }
    
    public func reorderVideoList(){
        if !videoList.isEmpty {
            for videoPosition in 1...(videoList.count) {
                videoList[videoPosition - 1].setPosition(videoPosition)
            }
            
            self.setVideoList(videoList)
            updateModificationDate()
        }
    }
    
    private func setUpTitle() -> String {
        var title = "\(Utils().giveMeTimeNow())"
        
        if let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String{
            title = appName.appending(title)
        }
        
        return title
    }
}
