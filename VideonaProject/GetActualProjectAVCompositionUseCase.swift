//
//  GetActualProjectAVComposition.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 1/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

public class GetActualProjectAVCompositionUseCase: NSObject {    
    public var compositionInSeconds:Double = 0.0

    public func getComposition(project:Project) -> VideoComposition{
        var videoTotalTime:CMTime = kCMTimeZero
        let transitionSeconds = project.transitionTime
        let transitionTime = CMTimeMakeWithSeconds(transitionSeconds, 600)

        let isMusicSet = project.isMusicSet
        let isVoiceOverSet = project.isVoiceOverSet
        
        // - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
        let mixComposition = AVMutableComposition()
        var videoComposition:AVMutableVideoComposition?
        var playerComposition = VideoComposition(mutableComposition: mixComposition)

        let audioMix: AVMutableAudioMix = AVMutableAudioMix()
        var audioMixParam: [AVMutableAudioMixInputParameters] = []
        
        let videosArray = project.getVideoList()
        // - Add assets to the composition
        let videoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo,
                                                        preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio,
                                                        preferredTrackID: Int32(kCMPersistentTrackID_Invalid))

        videosArray.forEach { (video) in
            //                let videoURL: NSURL = NSURL.init(fileURLWithPath: video.getMediaPath())
            let videoURL: NSURL = video.videoURL as NSURL
            let videoAsset = AVAsset.init(url: videoURL as URL)
            
            do {
                
                let startTime = CMTimeMake(Int64(video.getStartTime() * 600), 600)
                let stopTime = CMTimeMake(Int64(video.getStopTime() * 600), 600)
                let duration = stopTime - startTime
                let range = CMTimeRangeMake(startTime, duration)
                
                try videoTrack.insertTimeRange(range,
                                               of: videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0] ,
                                               at: videoTotalTime)
                
                try audioTrack.insertTimeRange(range,
                                               of: videoAsset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
                                               at: videoTotalTime)
                
                let audiocParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: audioTrack)
                audiocParam.trackID = audioTrack.trackID
                audiocParam.setVolume(project.projectOutputAudioLevel, at: kCMTimeZero)
                audioMixParam.append(audiocParam)
                
                playerComposition.addTransition(trackTimeRange: CMTimeRangeMake(videoTotalTime, duration),
                                                transitionTime: CMTimeMakeWithSeconds(project.transitionTime, 600))
                
                videoTotalTime = CMTimeAdd(videoTotalTime, duration)
                
                               Utils().debugLog("el tiempo total del video es: \(videoTotalTime.seconds)")
            } catch _ {
                Utils().debugLog("Error trying to create videoTrack")
            }
            
            compositionInSeconds = videoTotalTime.seconds
        }
        
        if isMusicSet{
            setMusicToProject(audioMixParams: &audioMixParam,
                              mixComposition: mixComposition,
                              musicPath: project.getMusic().getMusicResourceId(),
                              volume: Float(project.getMusic().audioLevel))
        }else{
            AudioTransitions(transitionTime: transitionTime).setAudioTransition(mutableComposition: mixComposition,
                                                                                audioMixParams: &audioMixParam,
                                                                                maxVolume: project.projectOutputAudioLevel)
        }
        
        if isVoiceOverSet {
            //TODO: change to new voice over params
            
            setVoiceOverToProject(audioMixParams: &audioMixParam,
                                  mixComposition: mixComposition,
                                  audios: project.voiceOver)
        }

        audioMix.inputParameters = audioMixParam
        playerComposition.audioMix = audioMix

        if mixComposition.duration.seconds > 0{
            
            videoComposition = AVMutableVideoComposition(propertiesOf: mixComposition)
            let resolutionSize = Resolution.init(AVResolution: project.getProfile().getResolution())
            videoComposition?.renderSize = CGSize(width: resolutionSize.width, height: resolutionSize.height)
            videoComposition?.customVideoCompositorClass = VideoFilterCompositor.self
            playerComposition.videoComposition = videoComposition
            
            VideoTransitions(transitionTime: transitionTime)
            .setInstructions(videonaComposition: playerComposition,
                             transitionColor: project.transitionColor,
                             filters: getFilters(fromProject: project))
        }

        return playerComposition
    }
    
    public func getFilters(fromProject project:Project)->[CIFilter]{
        var filters:[CIFilter] = []
        
        let params = project.videoOutputParameters
        
        let colorControlFilter = CIFilter(name: "CIColorControls")!
        colorControlFilter.setValue(params.brightness, forKey: kCIInputBrightnessKey)
        colorControlFilter.setValue(params.saturation, forKey: kCIInputSaturationKey)
        colorControlFilter.setValue(params.contrast, forKey: kCIInputContrastKey)
        
        let exposureFilter = CIFilter(name: "CIExposureAdjust")!
        exposureFilter.setValue(params.exposure, forKey: kCIInputEVKey)
        
        filters.append(colorControlFilter)
        filters.append(exposureFilter)
        if let filter = project.videoFilter{
            filters.append(filter)
        }
        
        return filters
    }
    
    public func setMusicToProject(audioMixParams:inout [AVMutableAudioMixInputParameters],
                                  mixComposition:AVMutableComposition,
                                  musicPath:String,
                                  volume:Float){
        let audioURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: musicPath, ofType: "mp3")!)
        let audioAsset = AVAsset.init(url: audioURL as URL)
        
        let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio,
                                                                 preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        do {
            try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, mixComposition.duration),
                                           of: audioAsset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
                                           at: kCMTimeZero)
            let musicParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: audioTrack)
            musicParam.trackID = audioTrack.trackID
            musicParam.setVolume(volume, at: kCMTimeZero)
            audioMixParams.append(musicParam)
        } catch _ {
            Utils().debugLog("Error trying to create audioTrack")
        }
    }
    
    public func setVoiceOverToProject(audioMixParams:inout [AVMutableAudioMixInputParameters],
                               mixComposition:AVMutableComposition,
                               audios:[Audio]){
        for audio in audios{
            if FileManager.default.fileExists(atPath: audio.getMediaPath()){
                let audioURL = NSURL.init(fileURLWithPath: audio.getMediaPath())
                let audioAsset = AVAsset.init(url: audioURL as URL)
                
                let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio,
                                                                preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
                do {
                    let startTime = CMTimeMakeWithSeconds(audio.getStartTime(),600)
                    let duration = CMTimeMakeWithSeconds(audio.getDuration(),600)
                    let range = CMTimeRangeMake(kCMTimeZero, duration)
                    
                    try audioTrack.insertTimeRange(range,
                                                   of: audioAsset.tracks(withMediaType: AVMediaTypeAudio)[0],
                                                   at: startTime) 
                   
                    let voiceOverParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: audioTrack)
                    voiceOverParam.trackID = audioTrack.trackID
                    voiceOverParam.setVolume(audio.audioLevel, at: kCMTimeZero)
                    audioMixParams.append(voiceOverParam)
                } catch _ {
                    Utils().debugLog("Error trying to create audioTrack")
                }
            }
        }
    }
}
