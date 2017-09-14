//
//  AudioTransitions.swift
//  VideonaProject
//
//  Created by Alejandro Arjonilla Garcia on 11/11/16.
//  Copyright © 2016 videona. All rights reserved.
//

import Foundation
import AVFoundation

class AudioTransitions {
    let transitionTime: CMTime
    var maxVolume: Float = 1.0
    let minVolume: Float = 0.0

    init(transitionTime: CMTime) {
        self.transitionTime = transitionTime
    }

    func setAudioTransition(mutableComposition: AVMutableComposition,
                            audioMixParams:inout [AVMutableAudioMixInputParameters],
                            maxVolume: Float) {
        let audioTracks = mutableComposition.tracks(withMediaType: AVMediaTypeAudio)

        var fadeInTime = kCMTimeZero
        self.maxVolume = maxVolume

        for audioTrack in audioTracks {
            if (audioTrack.timeRange.end.seconds - fadeInTime.seconds) > 2 * transitionTime.seconds {

                let fadeInRange = CMTimeRangeMake(fadeInTime, transitionTime)

                let startFadeOut = CMTimeSubtract(audioTrack.timeRange.end,
                                                  transitionTime)
                let fadeOutRange = CMTimeRangeMake(startFadeOut, transitionTime)

                let fadeInParameter = AVMutableAudioMixInputParameters(track: audioTrack)
                fadeInParameter.setVolumeRamp(fromStartVolume: minVolume, toEndVolume: maxVolume, timeRange: fadeInRange)

                let fadeOutParameter = AVMutableAudioMixInputParameters(track: audioTrack)
                fadeOutParameter.setVolumeRamp(fromStartVolume: maxVolume, toEndVolume: minVolume, timeRange: fadeOutRange)

                audioMixParams.append(fadeInParameter)
                audioMixParams.append(fadeOutParameter)

                fadeInTime = audioTrack.timeRange.end
            }
        }
    }
}
