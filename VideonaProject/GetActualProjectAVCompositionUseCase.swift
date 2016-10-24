//
//  GetActualProjectAVComposition.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 1/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject

public class GetActualProjectAVCompositionUseCase: NSObject {    
    public var compositionInSeconds:Double = 0.0
    
    public func getComposition(project:Project) -> VideoComposition{
        var videoTotalTime:CMTime = kCMTimeZero

        let isMusicSet = project.isMusicSet
        let isVoiceOverSet = project.isVoiceOverSet
        
        // - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
        let mixComposition = AVMutableComposition()

        let audioMix: AVMutableAudioMix = AVMutableAudioMix()
        var audioMixParam: [AVMutableAudioMixInputParameters] = []
        
        var videoComposition:AVMutableVideoComposition?
        
        let videoTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        let audioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        let videosArray = project.getVideoList()
        // - Add assets to the composition
        if videosArray.count>0 {
            for count in 0...(videosArray.count - 1){
                let video = videosArray[count]
                // 2 - Get Video asset
                let videoURL: NSURL = NSURL.init(fileURLWithPath: video.getMediaPath())
                let videoAsset = AVAsset.init(URL: videoURL)
                
                do {
                    let startTime = CMTimeMake(Int64(video.getStartTime() * 1000), 1000)

                    let stopTime = CMTimeMake(Int64(video.getStopTime() * 1000), 1000)
                    
                    try videoTrack.insertTimeRange(CMTimeRangeMake(startTime,  stopTime),
                                                   ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeVideo)[0] ,
                                                   atTime: videoTotalTime)
                    
                    if isMusicSet == false {
                        try audioTrack.insertTimeRange(CMTimeRangeMake(startTime, stopTime),
                                                       ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeAudio)[0] ,
                                                       atTime: videoTotalTime)
                        let videoParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: audioTrack)
                        videoParam.trackID = audioTrack.trackID
                        videoParam.setVolume(project.projectOutputAudioLevel, atTime: kCMTimeZero)
                        audioMixParam.append(videoParam)
                    }
                    videoTotalTime = CMTimeAdd(videoTotalTime, (stopTime - startTime))

                    mixComposition.removeTimeRange(CMTimeRangeMake((videoTotalTime), (stopTime + videoTotalTime)))
                    Utils().debugLog("remove final range from (stopTime + videoTotalTime): \((stopTime.seconds + videoTotalTime.seconds)) \n to (videoAsset.duration + videoTotalTime): \((videoAsset.duration.seconds + videoTotalTime.seconds)) ")

                    Utils().debugLog("el tiempo total del video es: \(videoTotalTime.seconds)")
                } catch _ {
                    Utils().debugLog("Error trying to create videoTrack")
                    //                completionHandler("Error trying to create videoTrack",0.0)
                }
                
                compositionInSeconds = videoTotalTime.seconds
            }
            
            if isMusicSet{
                setMusicToProject(mixComposition,
                                  musicPath: project.getMusic().getMusicResourceId())
            }
            
            if isVoiceOverSet {
                setVoiceOverToProject(audioMixParam,
                                      mixComposition: mixComposition,
                                      audioPath: project.voiceOver.getMediaPath(),
                                      audioLevel: project.voiceOver.audioLevel)
            }
        }
        
        
        var playerComposition = VideoComposition(mutableComposition: mixComposition)
        
        audioMix.inputParameters = audioMixParam
        playerComposition.audioMix = audioMix
        
        if videoComposition != nil{
            playerComposition.videoComposition = videoComposition
        }
        
        return playerComposition
    }
    
    
    public func setMusicToProject(mixComposition:AVMutableComposition,
                           musicPath:String){
        let audioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(musicPath, ofType: "mp3")!)
        let audioAsset = AVAsset.init(URL: audioURL)
        
        let audioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio,
                                                                 preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        do {
            try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, mixComposition.duration),
                                           ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0] ,
                                           atTime: kCMTimeZero)
        } catch _ {
            Utils().debugLog("Error trying to create audioTrack")
        }
    }
    
    public func setVoiceOverToProject(mixAudioParams:[AVMutableAudioMixInputParameters],
                               mixComposition:AVMutableComposition,
                               audioPath:String,
                               audioLevel:Float){
        var audioParams = mixAudioParams

        let audioURL = NSURL.init(fileURLWithPath: audioPath)
        let audioAsset = AVAsset.init(URL: audioURL)
        
        let audioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio,
                                                                 preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        do {
            try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration),
                                           ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0] ,
                                           atTime: kCMTimeZero)
            let voiceOverParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: audioTrack)
            voiceOverParam.trackID = audioTrack.trackID
            voiceOverParam.setVolume(audioLevel, atTime: kCMTimeZero)
            audioParams.append(voiceOverParam)
        } catch _ {
            Utils().debugLog("Error trying to create audioTrack")
        }
    }
}