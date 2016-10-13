//
//  VideoComposition.swift
//  Pods
//
//  Created by Alejandro Arjonilla Garcia on 13/10/16.
//
//
import AVFoundation

struct VideoComposition{
    var mutableComposition:AVMutableComposition?
    var audioMix:AVAudioMix?
    var videoComposition:AVVideoComposition?
    
    init(mutableComposition:AVMutableComposition){
        self.mutableComposition = mutableComposition
    }
}