//
//  VideonaComposition.swift
//  VideonaProject
//
//  Created by Alejandro Arjonilla Garcia on 13/10/16.
//  Copyright © 2016 videona. All rights reserved.
//

import Foundation
import AVFoundation

public class VideoComposition{
    public static let videoTimeScale: Int32 = 600
    public var mutableComposition:AVMutableComposition?
    public var audioMix:AVAudioMix?
    public var videoComposition:AVMutableVideoComposition?
    public var layerAnimation:CALayer?
    public var fadeInTransitionTimeRanges: [CMTimeRange] = []
    public var fadeOutTransitionTimeRanges: [CMTimeRange] = []
    
    public init(mutableComposition:AVMutableComposition){
        self.mutableComposition = mutableComposition
    }
    
    public func addTransition(trackTimeRange: CMTimeRange,
                              transitionTime: CMTime){
        
        fadeInTransitionTimeRanges.append(CMTimeRange(start: trackTimeRange.start,
                                                      duration: transitionTime))
        
        fadeOutTransitionTimeRanges.append(CMTimeRange(start: CMTimeSubtract(trackTimeRange.end, transitionTime),
                                                       duration: transitionTime))
    }
}
