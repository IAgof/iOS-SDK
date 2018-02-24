//
//  SplitInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 4/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

open class SplitInteractor: NSObject, SplitInteractorInterface {
    open var delegate: SplitInteractorDelegate?
    open var project: Project?
    open var videoPosition: Int?

    public init(project: Project) {
        self.project = project
    }

    open func setVideoPosition(_ position: Int) {
        self.videoPosition = position
    }

    open func getVideoParams() {
        guard let video = project?.getVideoList()[videoPosition!] else {return}

        let videoDuration = (video.getStopTime() - video.getStartTime())

        delegate?.settSplitValue(Float(videoDuration/2))
        delegate?.setMaximumValue(Float(videoDuration))
    }

    open func setUpComposition(_ completion: (VideoComposition) -> Void) {
        var videoTotalTime: CMTime = kCMTimeZero

        guard let videoPos = videoPosition,
        let project = self.project,
        project.getVideoList().indices.contains(videoPos) else {
            return
        }
        let video = project.getVideoList()[videoPos]
        let mixComposition = AVMutableComposition()
        let videoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        let videoAsset = AVAsset.init(url: video.videoURL)
        do {
            let startTime = CMTimeMake(Int64(video.getStartTime() * 600), 600)
            let stopTime = CMTimeMake(Int64(video.getStopTime() * 600), 600)
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
            print("Error trying to create videoTrack")
        }

        let videonaComposition = VideoComposition(mutableComposition: mixComposition)
        let layer = getLayerToPlayer(video)
        videonaComposition.layerAnimation = layer
        completion(videonaComposition)
    }

    func getLayerToPlayer(_ video: Video) -> CALayer {
        guard let align = CATextLayerAttributes.VerticalAlignment(rawValue: video.textPositionToVideo) else {return CALayer()}
        let text = video.textToVideo

        let alignmentAttributes = CATextLayerAttributes().getAlignmentAttributesByType(type: align)

        let image = GetImageByTextUseCase().getTextImage(text: text, attributes: alignmentAttributes)
        let textImageLayer = CALayer()
        textImageLayer.contents = image.cgImage
        textImageLayer.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        textImageLayer.contentsScale = UIScreen.main.scale

        return textImageLayer
    }

    open func setSplitVideosToProject(_ splitTime: Double) {
        guard var videoList = project?.getVideoList(),
        let videoPosition = self.videoPosition else {return}
        if videoList.indices.contains(videoPosition) {
            let videoCopy = videoList[videoPosition].copy() as? Video
            videoCopy?.setStartTime((videoCopy?.getStartTime())! + splitTime)
            videoCopy?.setIsSplit(true)
            videoList.insert(videoCopy!, at: (videoPosition + 1))
            let video = videoList[videoPosition]
            video.setStopTime(video.getStartTime() + splitTime)
            video.setIsSplit(true)
        }
        project?.setVideoList(videoList)
        project?.reorderVideoList()
    }
}
