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
    let transitionTime: CMTime

    init(transitionTime: CMTime) {
        self.transitionTime = transitionTime
    }

    func setInstructions(videonaComposition: VideoComposition,
                         transitionColor: CIColor,
                         filters: [CIFilter]) {

        guard let mutableComposition = videonaComposition.mutableComposition else {return}
        guard let videoComposition = videonaComposition.videoComposition else {return}
        let instruction = AVMutableVideoCompositionInstruction()
        guard let videoTrack = mutableComposition.tracks(withMediaType: AVMediaTypeVideo).first else {return}

        //TODO: SOLVE issue with custom compositor
//        let eagl = EAGLContext(api: EAGLRenderingAPI.openGLES2)
//        let context = CIContext(eaglContext: eagl!, options: [kCIContextWorkingColorSpace : NSNull()])
//        let instruction = VideoFilterCompositionInstruction(track: videoTrack,
//                                                            filters: filters, context: context,transitionColor:transitionColor,
//                                                            transitionTime:transitionTime,
//                                                            fadeInTransitionTimeRanges: videonaComposition.fadeInTransitionTimeRanges,
//                                                            fadeOutTransitionTimeRanges: videonaComposition.fadeOutTransitionTimeRanges)
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, mutableComposition.duration)

        setInstructionsToTrack(instruction: instruction,
                                       videoTrack: videoTrack,
                                       transitionTime: transitionTime,
                                       atTime: kCMTimeZero,
                                       videonaComposition: videonaComposition)

        videoComposition.instructions = [instruction]
    }

    func setInstructionsToTrack(instruction: AVMutableVideoCompositionInstruction,
                                videoTrack: AVAssetTrack,
                                transitionTime: CMTime,
                                atTime: CMTime,
                                videonaComposition: VideoComposition) {
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        layerInstruction.setOpacity(1, at: kCMTimeZero)

        //Adjust size
        videonaComposition.resolutions.forEach { (resolutionTime) in
            layerInstruction.setTransform( getTransform(desireSize: videonaComposition.resolution?.size ?? videoTrack.naturalSize,
                                                        actualSize: resolutionTime.resolution), at: resolutionTime.time)
        }
        instruction.layerInstructions.append(layerInstruction)
    }

    func getTransform(desireSize: CGSize,
                             actualSize: CGSize) -> CGAffineTransform {
        let scaleToTransformX = (desireSize.width / actualSize.width)
        let scaleToTransformY = (desireSize.height / actualSize.height)

        return CGAffineTransform(scaleX: scaleToTransformX, y: scaleToTransformY)
    }
}
