//
//  AddVideoToProjectUseCase.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 21/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

public class AddVideoToProjectUseCase: NSObject {
    
    public func add(videoPath:String,
             title:String,
             project:Project){
        var videoList = project.getVideoList()
        
        let video = Video.init(title: title,
                               mediaPath: videoPath)
        video.setPosition(videoList.count + 1)
        
        videoList.append(video)
        
        project.setVideoList(videoList)
    }
    
    public func add(video:Video,
             position:Int,
             project:Project){
        
        var videoList = project.getVideoList()
        
        videoList.insert(video, atIndex: position)
        
        project.setVideoList(videoList)
    }
    
    public func updateVideoParams(project:Project) {
        let videoList = project.getVideoList()
        videoList.last?.mediaRecordedFinished()
    }
}