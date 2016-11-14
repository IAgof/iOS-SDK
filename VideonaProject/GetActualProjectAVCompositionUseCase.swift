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
    let transitionSeconds:Double = 1

    public func getComposition(project:Project) -> VideoComposition{
        var videoTotalTime:CMTime = kCMTimeZero
        let transitionTime = CMTimeMakeWithSeconds(transitionSeconds, 600)

        let isMusicSet = project.isMusicSet
        let isVoiceOverSet = project.isVoiceOverSet
        
        // - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
        let mixComposition = AVMutableComposition()
        var videoComposition:AVMutableVideoComposition?

        let audioMix: AVMutableAudioMix = AVMutableAudioMix()
        var audioMixParam: [AVMutableAudioMixInputParameters] = []
        
        let videosArray = project.getVideoList()
        // - Add assets to the composition
        if videosArray.count>0 {
            for count in 0...(videosArray.count - 1){
                let videoTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo,
                                                                             preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
                let audioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio,
                                                                             preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
                let video = videosArray[count]
                // 2 - Get Video asset
                //                let videoURL: NSURL = NSURL.init(fileURLWithPath: video.getMediaPath())
                let videoURL: NSURL = video.videoURL
                let videoAsset = AVAsset.init(URL: videoURL)
                
                do {
                    let startTime = CMTimeMake(Int64(video.getStartTime() * 1000), 1000)
                    let stopTime = CMTimeMake(Int64(video.getStopTime() * 1000), 1000)
                    let duration = stopTime - startTime
                    let range = CMTimeRangeMake(startTime, duration)
                    
                    try videoTrack.insertTimeRange(range,
                                                   ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeVideo)[0] ,
                                                   atTime: videoTotalTime)
                    
                    if isMusicSet == false {
                        try audioTrack.insertTimeRange(range,
                                                       ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeAudio)[0] ,
                                                       atTime: videoTotalTime)
                    }
                    videoTotalTime = CMTimeAdd(videoTotalTime, duration)
                    videoTotalTime = CMTimeSubtract(videoTotalTime, transitionTime)
                    
                    Utils().debugLog("el tiempo total del video es: \(videoTotalTime.seconds)")
                } catch _ {
                    Utils().debugLog("Error trying to create videoTrack")
                }
                
                compositionInSeconds = videoTotalTime.seconds
            }
            
            if isMusicSet{
                setMusicToProject(audioMixParam,
                                  mixComposition: mixComposition,
                                  musicPath: project.getMusic().getMusicResourceId())
            }else{
                 AudioTransitions(transitionTime: transitionTime).setAudioTransition(mixComposition, audioMix: audioMix)
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
        
        if mixComposition.duration.seconds > 0{
            videoComposition = AVMutableVideoComposition(propertiesOfAsset: mixComposition)
            
            VideoTransitions(transitionTime: transitionTime).setInstructions(mixComposition,
                                 videoComposition: videoComposition!)
        }

        playerComposition.videoComposition = videoComposition
        return playerComposition
    }
    
    public func setMusicToProject(mixAudioParams:[AVMutableAudioMixInputParameters],
                                  mixComposition:AVMutableComposition,
                                  musicPath:String){
        var audioParams = mixAudioParams
        
        let audioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(musicPath, ofType: "mp3")!)
        let audioAsset = AVAsset.init(URL: audioURL)
        
        let audioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio,
                                                                 preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        do {
            try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, mixComposition.duration),
                                           ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0] ,
                                           atTime: kCMTimeZero)
            let musicParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: audioTrack)
            musicParam.trackID = audioTrack.trackID
            musicParam.setVolume(1, atTime: kCMTimeZero)
            audioParams.append(musicParam)
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