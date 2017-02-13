//
//  TrimInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 2/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

open class TrimInteractor: NSObject,TrimInteractorInterface {
    open var delegate:TrimInteractorDelegate?
    open var project: Project?
    
    var videoPosition:Int?
    var videoSelected:Video?
    
    var startTime:Float = 0.0
    var stopTime:Float = 0.0
    
    
    public init(project:Project){
        self.project = project
    }
    
    
    open func setVideoPosition(_ position: Int) {
        self.videoPosition = position
    }
    
    open func getVideoParams() {
        guard let video = project?.getVideoList()[videoPosition!]else {return}

        startTime = Float(video.getStartTime())
        stopTime = Float(video.getStopTime())
        let duration = video.getFileStopTime()
        
        delegate?.setLowerValue(startTime)
        delegate?.setUpperValue(stopTime)
        delegate?.setMaximumValue(Float(duration))
        
        
        delegate?.updateParamsFinished()
    }
    
    open func setParametersOnVideoSelectedOnProjectList(_ startTime:Float,
                                                   stopTime:Float){
        guard let videoList = project?.getVideoList() else {return}
        
        videoList[videoPosition!].setStopTime(Double(stopTime))
        videoList[videoPosition!].setStartTime(Double(startTime))
        
        project?.setVideoList(videoList)
    }
    
    open func setParametersOnVideoSelected(_ startTime:Float,
                                      stopTime:Float){
        videoSelected = project?.getVideoList()[videoPosition!].copy() as? Video
        
//        videoSelected!.setStopTime(Double(stopTime))
//        videoSelected!.setStartTime(Double(startTime))
        
        self.startTime = startTime
        self.stopTime = stopTime
    }
    
    open func setUpComposition(_ completion:(VideoComposition)->Void) {
        var videoTotalTime:CMTime = kCMTimeZero
        
        guard let videoPos = videoPosition else {
            return
        }
        
        guard let video = project?.getVideoList()[videoPos]else {return}
        
        let mixComposition = AVMutableComposition()

        let videoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        
        // 2 - Get Video asset
        let videoAsset = AVAsset.init(url: video.videoURL)
        
        do {
            let startTime = CMTimeMake(Int64(self.startTime * 1000), 1000)
            let stopTime = CMTimeMake(Int64(self.stopTime * 1000), 1000)
            
            let timeRangeInsert = CMTimeRangeMake(startTime, stopTime)
            
            try videoTrack.insertTimeRange(timeRangeInsert,
                                           of: videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0] ,
                                           at: kCMTimeZero)
            
            try audioTrack.insertTimeRange(timeRangeInsert,
                                           of: videoAsset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
                                           at: kCMTimeZero)
            videoTotalTime = CMTimeAdd(videoTotalTime, (stopTime - startTime))

            mixComposition.removeTimeRange(CMTimeRangeMake((videoTotalTime), (stopTime + videoTotalTime)))
        } catch _ {
            debugPrint("Error trying to create videoTrack")
            //                completionHandler("Error trying to create videoTrack",0.0)
        }
        
        videoSelected = nil
        var videonaComposition = VideoComposition(mutableComposition: mixComposition)
        if let actualProject = project {
            let video = actualProject.getVideoList()[videoPosition!]
            
            let layer = getLayerToPlayer(video)
            videonaComposition.layerAnimation = layer
        }
        
        completion(videonaComposition)
    }
    
    func getLayerToPlayer(_ video: Video)->CALayer{
        guard let align = CATextLayerAttributes.VerticalAlignment(rawValue: video.textPositionToVideo) else{return CALayer()}
        let text = video.textToVideo
        
        let alignmentAttributes = CATextLayerAttributes().getAlignmentAttributesByType(type: align)
        
        let image = GetImageByTextUseCase().getTextImage(text: text, attributes: alignmentAttributes)
        let textImageLayer = CALayer()
        textImageLayer.contents = image.cgImage
        textImageLayer.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        textImageLayer.contentsScale = UIScreen.main.scale
        
        return textImageLayer
    }
}
