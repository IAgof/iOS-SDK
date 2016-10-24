//
//  VideonaComposition.swift
//  VideonaProject
//
//  Created by Alejandro Arjonilla Garcia on 13/10/16.
//  Copyright © 2016 videona. All rights reserved.
//

import Foundation
import AVFoundation

public struct VideoComposition{
    public var mutableComposition:AVMutableComposition?
    public var audioMix:AVAudioMix?
    public var videoComposition:AVMutableVideoComposition?
    public var layerAnimation:CALayer?
    
    public init(mutableComposition:AVMutableComposition){
        self.mutableComposition = mutableComposition
    }
}