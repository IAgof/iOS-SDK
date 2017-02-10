//
//  DuplicateInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 4/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject

open class DuplicateInteractor: NSObject,DuplicateInteractorInterface {
    open var delegate:DuplicateInteractorDelegate?
    open var project:Project?
    
    open var videoPosition:Int?{
        didSet{
            setStartAndStopParams()
        }
    }
    
    open var startTime:Float = 0.0
    open var stopTime:Float = 0.0
    open var mediaURL:URL?
    
    
    public init(project:Project){
        self.project = project
    }
    
    open func setVideoPosition(_ position: Int) {
        self.videoPosition = position
    }
    
    open func setStartAndStopParams(){
        guard let videoPosition = videoPosition else{return}
        guard let actualProject = project else{return}
        
        if actualProject.getVideoList().indices.contains(videoPosition){
            guard let video = project?.getVideoList()[videoPosition] else {return}
            
            self.startTime = Float(video.getStartTime())
            self.stopTime = Float(video.getStopTime())
            self.mediaURL = video.videoURL
        }

    }
    
    open func setUpComposition(_ videoSelectedIndex: Int,
                          completion:(VideoComposition)->Void) {

        
        let mixComposition = AVMutableComposition()
        
        let videoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        
        // 2 - Get Video asset
        guard let videoURL = mediaURL else{
            return
        }
        
        let videoAsset = AVAsset.init(url: videoURL)
        
        do {
            let stopTime = CMTimeMake(Int64(self.stopTime * 1000), 1000)
            let startTime = CMTimeMake(Int64(self.startTime * 1000), 1000)
            
            try videoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration),
                                           of: videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0] ,
                                           at: kCMTimeZero)
            try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration),
                                           of: videoAsset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
                                           at: kCMTimeZero)
            mixComposition.removeTimeRange(CMTimeRangeMake(kCMTimeZero, startTime))
            mixComposition.removeTimeRange(CMTimeRangeMake(stopTime, videoAsset.duration))
        } catch _ {
            print("Error trying to create videoTrack")
            //                completionHandler("Error trying to create videoTrack",0.0)
        }
        
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
    
    open func setDuplicateVideoToProject(_ numberDuplicates: Int) {
        
        for i in 1...(numberDuplicates - 1){
            guard let video = (project?.getVideoList()[videoPosition!].copy() as? Video) else {return}

            self.add(video,
                     position: videoPosition!)
                project?.reorderVideoList()
        }
    }
    
    open func add(_ video:Video,
             position:Int){
        
        guard var videoList = project?.getVideoList() else{return}
        
        videoList.insert(video, at: position)
        
        project?.setVideoList(videoList)
    }
    
    open func getThumbnail(_ frame:CGRect) {
        guard let videoURL = mediaURL else{
            return
        }
        
        let asset = AVURLAsset(url: videoURL, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        
        var cgImage:CGImage?
        do {
            cgImage =  try imgGenerator.copyCGImage(at: CMTime.init(value: 1, timescale: 10), actualTime: nil)
            print("Thumbnail image gets okay")
            
            // !! check the error before proceeding
            let thumbnail = UIImage(cgImage: cgImage!)

            delegate?.setThumbnail(thumbnail)

        } catch {
            print("Thumbnail error \nSomething went wrong!")
        }
    }
}
