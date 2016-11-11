//
//  VideoTransitions.swift
//  VideonaProject
//
//  Created by Alejandro Arjonilla Garcia on 11/11/16.
//  Copyright © 2016 videona. All rights reserved.
//

import Foundation
import AVFoundation

class VideoTransitions {
    let transitionTime:CMTime
    
    init(transitionTime:CMTime){
        self.transitionTime = transitionTime
    }
    
    func setInstructions(mutableComposition:AVMutableComposition,
                         videoComposition:AVMutableVideoComposition){

        let numberOfVideos = (mutableComposition.tracksWithMediaType(AVMediaTypeVideo).count)
        let instruction = AVMutableVideoCompositionInstruction()
        
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
}