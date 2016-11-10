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
                        let videoParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: audioTrack)
                        videoParam.trackID = audioTrack.trackID
                        videoParam.setVolume(project.projectOutputAudioLevel, atTime: kCMTimeZero)
                        audioMixParam.append(videoParam)
                    }
                    videoTotalTime = CMTimeAdd(videoTotalTime, duration)
                    videoTotalTime = CMTimeSubtract(videoTotalTime,  CMTimeMakeWithSeconds(1, 600))
                    
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
            
            self.setInstructions(mixComposition,
                                 videoComposition: videoComposition!)
        }

        playerComposition.videoComposition = videoComposition
        return playerComposition
    }
    
    func setInstructions(mutableComposition:AVMutableComposition,
                   videoComposition:AVMutableVideoComposition){
        
        let numberOfVideos = (mutableComposition.tracksWithMediaType(AVMediaTypeVideo).count)
        let instruction = AVMutableVideoCompositionInstruction()
        
        let transitionTime = CMTimeMakeWithSeconds(1, 600)
        var fadeInTime = kCMTimeZero
        
        for videoPos in 0...numberOfVideos{
            if videoPos != numberOfVideos{
                let video = mutableComposition.tracksWithMediaType(AVMediaTypeVideo)[videoPos]
                
                if (video.timeRange.end.seconds - fadeInTime.seconds) > 2 * transitionTime.seconds {
                    setInstructionsToTrack(instruction,
                                           videoTrack: video,
                                           transitionTime: transitionTime,
                                           atTime: fadeInTime,
                                           videoComposition: videoComposition)
                }
                
                print("video timeRange end")
                print(video.timeRange.end.seconds)
                
                fadeInTime = video.timeRange.end
            }
        }
        
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, mutableComposition.duration)
        
        videoComposition.instructions = [instruction]
    }
    
    func setInstructionsToTrack(instruction:AVMutableVideoCompositionInstruction,
                         videoTrack:AVAssetTrack,
                         transitionTime:CMTime,
                         atTime:CMTime,
                         videoComposition:AVMutableVideoComposition){
        
        let timeRangeFadeIn:CMTimeRange!
        
        if atTime.seconds != 0{
            let time = CMTimeSubtract(atTime, transitionTime)
            timeRangeFadeIn = CMTimeRangeMake(time, transitionTime)
        }else{
            timeRangeFadeIn = CMTimeRangeMake(atTime, transitionTime)
        }
        
        print("timeRange fade in start seconds")
        print(timeRangeFadeIn.start.seconds)
        
        print("timeRange fade in end seconds")
        print(timeRangeFadeIn.end.seconds)
        
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        //Fade in
        layerInstruction.setOpacityRampFromStartOpacity(0, toEndOpacity: 1, timeRange: timeRangeFadeIn)
        
        //Fade out
        let newTransitionTime = CMTimeSubtract(videoTrack.timeRange.end, transitionTime)
        let timeRangeFadeOut = CMTimeRangeMake(newTransitionTime, transitionTime)
        
        print("timeRange fade out start seconds")
        print(timeRangeFadeOut.start.seconds)
        
        print("timeRange fade out end seconds")
        print(timeRangeFadeOut.end.seconds)
        
        layerInstruction.setOpacityRampFromStartOpacity(1, toEndOpacity: 0, timeRange: timeRangeFadeOut)
        
        //Adjust size
        setTransformToLayer(videoComposition.renderSize,
                            actualSize: videoTrack.naturalSize,
                            layer: layerInstruction)
        
        instruction.layerInstructions.append(layerInstruction)
    }
    
    func setTransformToLayer(desireSize:CGSize,
                             actualSize:CGSize,
                             layer:AVMutableVideoCompositionLayerInstruction){
        let scaleToTransformX = desireSize.width / actualSize.width
        let scaleToTransformY = desireSize.height / actualSize.height
        
        if scaleToTransformX != 1 && scaleToTransformY != 1 {
            let transform = CGAffineTransformMakeScale(scaleToTransformX, scaleToTransformY)
            layer.setTransform(transform, atTime: kCMTimeZero)
        }
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