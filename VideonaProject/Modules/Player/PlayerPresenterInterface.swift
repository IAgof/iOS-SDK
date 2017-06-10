//
//  PlayerPresenterInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 13/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

public protocol PlayerPresenterInterface {
    func createVideoPlayer(_ composition:VideoComposition)
    func createVideoPlayer(_ videoURL:URL)
    func setVideoComposition(videoComposition: AVMutableVideoComposition)
    func layoutSubViews()
    func onVideoStops()
    func pauseVideo()
    func videoPlayerViewTapped()
    func pushPlayButton()
    func updateSeekBar()
    func seekToTime(_ time:Float)
    func isPlayingVideo()->Bool
    
    func setPlayerVolume(_ level:Float)
    func setPlayerMuted(_ state:Bool)
    
    func enablePlayerInteraction()
    func disablePlayerInteraction()
    
    func setAVSyncLayer(_ layer:CALayer)
    func removeFinishObserver()
    func setAudioMix(audioMix value:AVAudioMix)
    
    func removePlayer()
    func timeLabels(isHidden state:Bool)
}


public protocol PlayerDelegate {
    var isPlaying: Bool{get set}
    func createVideoPlayer()
    func createVideoPlayerByPath(_ videoURL:URL)
    func setPlayerMovieComposition(_ composition:AVMutableComposition)
    func setPlayerAudioMix(_ audioMix:AVAudioMix)
    func setPlayerVideoComposition(_ videoComposition:AVMutableVideoComposition)
    func updateLayers()
    func getView()->UIView
    func setUpVideoFinished()
    func pauseVideoPlayer()
    func playVideoPlayer()
    func updateSeekBarOnUI()
    func seekToTime(_ time: Float)
    func setPlayerVolume(_ level:Float)
    func setPlayerMuted(_ state:Bool)
    
    func disableSliderAndInteractions()
    func enableSliderAndInteractions()
    
    func setAVSyncLayer(_ layer:CALayer)
    func removeAVSyncLayers()
    func setAudioMix(audioMix value:AVAudioMix)
    
    func removeAudioMix()
    func removeVideoComposition()
    func removeFinishObserver()
    func removePlayer()
    func setTimeLabels(isHidden state:Bool)

}
