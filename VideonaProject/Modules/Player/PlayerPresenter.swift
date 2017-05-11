//
//  PlayerPresenter.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 13/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

open class PlayerPresenter:NSObject,PlayerPresenterInterface{
    
    //MARK: - VIPER
    open var playerInteractor: PlayerInteractorInterface?
    open var playerDelegate: PlayerDelegate?
    open var wireframe: PlayerWireframe?
    
    //MARK: - Variables
    open var isPlaying = false
    
    //MARK: - Init
    open func createVideoPlayer(_ composition:VideoComposition) {
        guard let mutableComposition = composition.mutableComposition else{
            print("No mutable composition")
            return
        }
        
        if let audioMix = composition.audioMix{
            playerDelegate?.setPlayerAudioMix(audioMix)
        }else{
            playerDelegate?.removeAudioMix()
        }
        
        if let videoComposition = composition.videoComposition{
            playerDelegate?.setPlayerVideoComposition(videoComposition)
        }else{
            playerDelegate?.removeVideoComposition()
        }
        
        playerDelegate?.setPlayerMovieComposition(mutableComposition)
        DispatchQueue.main.async{
            self.playerDelegate?.createVideoPlayer()
            
            if let layerAnimation = composition.layerAnimation{
                self.playerDelegate?.removeAVSyncLayers()
                
                self.playerDelegate?.setAVSyncLayer(layerAnimation)
            }
        }
    }
    
    open func createVideoPlayer(_ videoURL: URL) {
        DispatchQueue.main.async {
            self.playerDelegate?.createVideoPlayerByPath(videoURL)
            
            self.playerDelegate?.removeAVSyncLayers()
        }
    }
    
    public func setVideoComposition(videoComposition: AVMutableVideoComposition){
        self.playerDelegate?.setPlayerVideoComposition(videoComposition)
    }
    
    open func layoutSubViews(){
        if self.playerDelegate?.getView() != nil{
            self.playerDelegate?.updateLayers()
        }
    }
    
    //MARK: - Handler
    open func onVideoStops() {
        isPlaying = false
        
        playerDelegate?.setUpVideoFinished()
    }
    
    open func pauseVideo() {
        if isPlaying {
            isPlaying = false
            playerDelegate?.pauseVideoPlayer()
        }
    }
    
    open func pushPlayButton() {
        if(isPlaying){
            playerDelegate?.pauseVideoPlayer()
            isPlaying = false
        }else{
            playPlayer()
        }
    }
    
    open func videoPlayerViewTapped() {
        if(isPlaying){
            playerDelegate?.pauseVideoPlayer()
            isPlaying = false
        }else{
            playPlayer()
        }
    }
    
    open func playPlayer() {
        playerDelegate?.playVideoPlayer()
        isPlaying = true
    }
    
    open func updateSeekBar() {
        playerDelegate!.updateSeekBarOnUI()
    }
    
    open func seekToTime(_ time:Float){
        playerDelegate?.seekToTime(time)
    }
    open func isPlayingVideo() -> Bool {
        return self.isPlaying
    }
    
    open func setPlayerVolume(_ level: Float) {
        playerDelegate?.setPlayerVolume(level)
    }
    open func setPlayerMuted(_ state: Bool) {
        playerDelegate?.setPlayerMuted(state)
    }
    
    open func enablePlayerInteraction() {
        playerDelegate?.enableSliderAndInteractions()
    }
    
    open func disablePlayerInteraction() {
        playerDelegate?.disableSliderAndInteractions()
    }
        
    open func setAVSyncLayer(_ layer: CALayer) {
        DispatchQueue.main.async(execute: {
            self.playerDelegate?.removeAVSyncLayers()
            
            self.playerDelegate?.setAVSyncLayer(layer)
        })
    }
    
    public func removeFinishObserver() {
        playerDelegate?.removeFinishObserver()
    }
    
    public func setAudioMix(audioMix value: AVAudioMix) {
        playerDelegate?.setAudioMix(audioMix: value)
    }
    public func removePlayer() {
        playerDelegate?.removePlayer()
    }
    
    public func timeLabels(isHidden state: Bool) {
        playerDelegate?.setTimeLabels(isHidden: state)
    }
}
