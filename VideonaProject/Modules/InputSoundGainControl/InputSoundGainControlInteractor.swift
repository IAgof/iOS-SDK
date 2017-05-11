//
//  InputSoundGainControlInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreAudio

class InputSoundGainControlInteractor: InputSoundGainControlInteractorInterface {
    //MARK : VIPER
    var delegate:InputSoundGainControlInteractorDelegate?
    var audioSession:AVCaptureSession?
    
    var maxZoomFactor = CGFloat(10)

    init(presenter:InputSoundGainControlPresenter){
        delegate = presenter
    }
    
    func setInputGainLevel(_ value:Float){
        let session = AVAudioSession.sharedInstance()

        do{
            print("Input gain settable \(session.isInputGainSettable)")
            try session.setInputGain(value)
            
            print("AVCaptureSession gain")
            print(session.inputGain)
            
        }catch _ as NSError{
//            print(e.localizedDescription, e.localizedFailureReason, e.localizedRecoveryOptions, e.localizedRecoverySuggestion)
        }
    }
}

