//
//  VideoTransitions.swift
//  VideonaProject
//
//  Created by Alejandro Arjonilla Garcia on 11/11/16.
//  Copyright © 2016 videona. All rights reserved.
//

import Foundation
import AVFoundation
import CoreImage

class VideoTransitions {
    let transitionTime:CMTime
    
    init(transitionTime:CMTime){
        self.transitionTime = transitionTime
    }
    
    func setInstructions(mutableComposition:AVMutableComposition,
                         videoComposition:AVMutableVideoComposition,
                         transitionColor:CIColor,
                         filters:[CIFilter]){

        let numberOfVideos = (mutableComposition.tracks(withMediaType: AVMediaTypeVideo).count)
        let eagl = EAGLContext(api: EAGLRenderingAPI.openGLES2)
        let context = CIContext(eaglContext: eagl!, options: [kCIContextWorkingColorSpace : NSNull()])
        
        let instruction = VideoFilterCompositionInstruction(tracks: mutableComposition.tracks(withMediaType: AVMediaTypeVideo), filters: filters, context: context,transitionColor:transitionColor, transitionTime:transitionTime)
        
        var fadeInTime = kCMTimeZero
        
        for videoPos in 0...numberOfVideos{
            if videoPos != numberOfVideos{
                let video = mutableComposition.tracks(withMediaType: AVMediaTypeVideo)[videoPos]
                
                if (video.timeRange.end.seconds - fadeInTime.seconds) > 2 * transitionTime.seconds {
                    setInstructionsToTrack(instruction: instruction,
                                           videoTrack: video,
                                           transitionTime: transitionTime,
                                           atTime: fadeInTime,
                                           videoComposition: videoComposition)
                }
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
            timeRangeFadeIn = CMTimeRangeMake(atTime, transitionTime)
        }else{
            timeRangeFadeIn = CMTimeRangeMake(atTime, transitionTime)
        }
        
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        //Fade in
        layerInstruction.setOpacityRamp(fromStartOpacity: 0, toEndOpacity: 1, timeRange: timeRangeFadeIn)
        
        //Fade out
        let newTransitionTime = CMTimeSubtract(videoTrack.timeRange.end, transitionTime)
        let timeRangeFadeOut = CMTimeRangeMake(newTransitionTime, transitionTime)
        
        layerInstruction.setOpacityRamp(fromStartOpacity: 1, toEndOpacity: 0, timeRange: timeRangeFadeOut)
        
        //Adjust size
        setTransformToLayer(desireSize: videoComposition.renderSize,
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
            let transform = CGAffineTransform(scaleX: scaleToTransformX, y: scaleToTransformY)
            layer.setTransform(transform, at: kCMTimeZero)
        }
    }
}
