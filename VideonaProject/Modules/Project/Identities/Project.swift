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
import CoreLocation

public struct ProjectInfo {
    public var title: String = ""
    public var date: Date = Date()
    public var author: String = ""
    public var location: String = ""
    public var description: String = ""
    public var liveOnTape: Bool = false
    public var bRoll: Bool = false
    public var natVO: Bool = false
    public var interview: Bool = false
    public var graphics: Bool = false
    public var piece: Bool = false
}

open class Project: NSObject {
    public var projectInfo: ProjectInfo
    /**
     * The folder where de temp files of the project are stored
     */
    fileprivate var projectPath: String = ""

    /**
     * Path where exported videos are
     */
    fileprivate var exportedPath: String? {
        didSet {
            exportDate = Date()
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
    fileprivate var duration: Double = 0.0

    /**
     * Music to add to export video ( may be nil)
     */

    open var music: Music?

    open var isMusicSet: Bool {
        return music != nil
    }

    open var voiceOver: [Audio] = []

    open var isVoiceOverSet: Bool {
        if voiceOver.count != 0 {
            return true
        } else {
            return false
        }
    }

    open var projectOutputAudioLevel: Float = 1.0

    open var transitionTime: Double = 0

    public var  uuid = UUID().uuidString

    public var modificationDate: Date?

    public var exportDate: Date?

    public var videoOutputParameters: VideoOutputParameters = VideoOutputParameters()

    public var videoFilter: CIFilter?

    public var transitionColor = CIColor(red: 255, green: 255, blue: 255)
//    public var transitionColor = CIColor(red: 0, green: 0, blue: 0)
    public var hasWatermark: Bool
    override public init() {
        //TODO: Default value?
        self.projectInfo = ProjectInfo()
        self.hasWatermark = true
        super.init()
        self.projectPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        self.profile = Profile()
        self.duration = 0
        videoList = Array<Video>()
        modificationDate = Date()
        
        self.projectInfo.title = setUpTitle()
    }

    public init(title: String, rootPath: String, profile: Profile) {
        //TODO: Default value?
        self.hasWatermark = true
        self.projectInfo = ProjectInfo()
        self.projectInfo.title = title
        self.projectPath = rootPath
        self.profile = profile
        videoList = Array<Video>()
        modificationDate = Date()
    }

    open func copyWithZone(_ zone: NSZone?) -> AnyObject {
        let copy = Project(title: projectInfo.title,
                           rootPath: projectPath,
                           profile: profile)

        copy.uuid = UUID().uuidString
        copy.videoList = videoList
        copy.duration = duration
        copy.music = music
        copy.voiceOver = voiceOver
        copy.projectOutputAudioLevel = projectOutputAudioLevel
        copy.transitionTime = transitionTime
        copy.modificationDate = modificationDate
        copy.exportDate = exportDate
        copy.hasWatermark = hasWatermark
        copy.projectInfo = projectInfo
        
        return copy
    }

    public func reloadProjectWith(project: Project) {
        self.projectInfo = project.projectInfo
        self.projectPath = project.projectPath
        self.profile = project.profile
        self.duration = project.duration
        voiceOver = project.voiceOver
        projectOutputAudioLevel = project.projectOutputAudioLevel
        music = project.music
        transitionTime = project.transitionTime

        videoList = project.videoList
        exportedPath = project.exportedPath

        videoOutputParameters = project.videoOutputParameters
        videoFilter = project.videoFilter
        hasWatermark = project.hasWatermark

        self.uuid = project.uuid
    }

    open func getProjectPath() -> String {
        return projectPath
    }

    open func setProjectPath(_ projectPath: String) {
        self.projectPath = projectPath
    }

    open func getProfile() -> Profile {
        return self.profile
    }

    open func setProfile(_ profile: Profile) {
        self.profile = profile
    }

    open func getDuration() -> Double {
        duration = 0
        for video in videoList {
            duration += video.getDuration()
        }
        return duration
    }

    open func setDuration(_ duration: Double) {
        self.duration = duration
    }

    open func clear() {
        self.projectInfo = ProjectInfo()
        self.projectInfo.title = setUpTitle()
        self.projectPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        self.profile = Profile()
        self.duration = 0
        self.uuid = UUID().uuidString
        updateModificationDate()

        videoList = Array<Video>()
        projectOutputAudioLevel = 1
        voiceOver = Array<Audio>()

        music = nil

        videoOutputParameters = VideoOutputParameters()
        videoFilter = nil
        exportedPath = nil
    }

    open func numberOfClips() -> Int {

        return videoList.count
    }

    open func setVideoList(_ list: Array<Video>) {
        self.videoList = list
    }

    open func getVideoList() -> Array<Video> {
        return videoList
    }

    fileprivate func getNewProjectExportPath() -> String {
        return "\(projectPath)/videoExported\(Utils().giveMeTimeNow()).m4v"
    }

    open func setExportedPath(path: String?) {
        self.exportedPath = path
    }

    open func getExportedPath() -> String? {
        return self.exportedPath
    }

    public func updateModificationDate() {
        modificationDate = Date()
    }

    public func reorderVideoList() {
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

        if let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String {
            title = appName.appending(title)
        }

        return title
    }
}
