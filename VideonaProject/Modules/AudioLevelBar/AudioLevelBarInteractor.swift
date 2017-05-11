//
//  AudioLevelBarInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreAudio

class AudioLevelBarInteractor: AudioLevelBarInteractorInterface {
    //MARK : VIPER
    var delegate:AudioLevelBarInteractorDelegate?
    var audioSession:AVCaptureSession?
    
    init(presenter:AudioLevelBarPresenter){
        delegate = presenter
    }
    
    func startToGetAudioLevel() {
        initAudioSession()
    }
    
    
    //MARK: - Inner functions
    var recorder: AVAudioRecorder!
    var levelTimer = Timer()
    var lowPassResults: Double = 0.0
    
    func initAudioSession(){
        
        do{
            let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            
            let documents: AnyObject = NSSearchPathForDirectoriesInDomains( FileManager.SearchPathDirectory.documentDirectory,  FileManager.SearchPathDomainMask.userDomainMask, true)[0] as AnyObject
            guard let documentDirectory = documents as? NSString else{return}
            let str =  documentDirectory.appendingPathComponent("recordTest.caf")
            
            let url = URL(fileURLWithPath: str as String)
            let recordSettings: [String : AnyObject] = [AVSampleRateKey:44100.0 as AnyObject,
                                                          AVNumberOfChannelsKey:2 as AnyObject,AVEncoderBitRateKey:12800 as AnyObject,
                                                          AVLinearPCMBitDepthKey:16 as AnyObject,
                                                          AVEncoderAudioQualityKey:AVAudioQuality.max.rawValue as AnyObject
                
            ]
            recorder = try AVAudioRecorder(url: url, settings: recordSettings)
            recorder.prepareToRecord()
            recorder.isMeteringEnabled = true
            
            recorder.record()
            
            self.levelTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(AudioLevelBarInteractor.levelTimerCallback), userInfo: nil, repeats: true)
            
        }catch{
            
        }
        
        
    }
    
    @objc func levelTimerCallback() {
        recorder.updateMeters()
                
        delegate?.setAudioLevel(recorder.averagePower(forChannel: 0))
    }
}

