//
//  AudioLevelBar.swift
//  VideonaProject
//
//  Created by Alejandro Arjonilla Garcia on 10.05.18.
//  Copyright © 2018 videona. All rights reserved.
//

import Foundation
import AVFoundation

public class AudioLevelBar: UIProgressView, AVAudioRecorderDelegate {
    // MARK: Variables
    var audioSession: AVAudioSession?
    var recorder: AVAudioRecorder!
    var levelTimer = Timer()
    var audioValue: Float = 0 {
        didSet {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: {
                  self.setProgress(self.audioValue, animated: true)
                })
                self.progressTintColor = self.audioColor
            }
        }
    }
    var recordSettings: [String : AnyObject] {
        return [AVSampleRateKey: 44100.0 as AnyObject,
                AVNumberOfChannelsKey: 2 as AnyObject, AVEncoderBitRateKey: 12800 as AnyObject,
                AVLinearPCMBitDepthKey: 16 as AnyObject,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue as AnyObject]
    }
    var getDocumentsDirectory: URL {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls.first!
        return documentDirectory.appendingPathComponent("recording.m4a")
    }
    var audioColor: UIColor {
        switch audioValue {
        case 0 ... 0.5:
            return #colorLiteral(red: 0.1294117647, green: 0.9411764706, blue: 0.3137254902, alpha: 1)
        case 0.5 ... 0.6:
            return #colorLiteral(red: 0.5803921569, green: 0.9098039216, blue: 0.4235294118, alpha: 1)
        case 0.6 ... 0.7:
            return #colorLiteral(red: 0.8186162114, green: 0.9107052684, blue: 0.4261362553, alpha: 1)
        case 0.75 ... 0.8:
            return #colorLiteral(red: 0.9173641205, green: 0.7471006513, blue: 0.2405435443, alpha: 1)
        case 0.8 ... 0.85:
            return #colorLiteral(red: 0.917493403, green: 0.6114624143, blue: 0.2497968078, alpha: 1)
        case 0.85 ... 0.9:
            return #colorLiteral(red: 0.9107058644, green: 0.5811718106, blue: 0.411336422, alpha: 1)
        case 0.9 ... 0.95:
            return #colorLiteral(red: 0.9142243266, green: 0.347694397, blue: 0.2898082733, alpha: 1)
        case 0.9 ... 1:
            return #colorLiteral(red: 0.999489367, green: 0.08244409412, blue: 0, alpha: 1)
        default: return .clear
        }
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    func configure() {
        self.backgroundColor = .clear
        self.tintColor = .clear
        self.trackTintColor = .clear
        initRecorder()
        start()
        self.levelTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(AudioLevelBar.levelTimerCallback), userInfo: nil, repeats: true)
    }
    // MARK: Functions
    func initRecorder() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
            guard let inputs = session.availableInputs else { return }
            
            // Find built-in mic
            guard let builtInMic = inputs.first(where: {
                $0.portType == AVAudioSessionPortBuiltInMic
            }) else { return }
            
            // Find the data source at the specified orientation
            guard let dataSource = builtInMic.dataSources?.first (where: {
                $0.orientation == AVAudioSessionOrientationBack
            }) else { return }
            
            // Set data source's polar pattern
            do {
                try dataSource.setPreferredPolarPattern(AVAudioSessionPolarPatternOmnidirectional)
            } catch let error as NSError {
                print("Unable to preferred polar pattern: \(error.localizedDescription)")
            }
            
            // Set the data source as the input's preferred data source
            do {
                try builtInMic.setPreferredDataSource(dataSource)
            } catch let error as NSError {
                print("Unable to preferred dataSource: \(error.localizedDescription)")
            }

            try recorder = AVAudioRecorder(url: getDocumentsDirectory, settings: settings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            audioSession = session
            if !recorder!.prepareToRecord() {
                print("Error: AVAudioRecorder prepareToRecord failed")
            }
        } catch {
            print("Error: AVAudioRecorder creation failed")
        }
    }
    
    func levelTimerCallback() {
        update()
        audioValue = (1.0 / 60.0) * (decibels + 60.0)
    }
    func start() {
        recorder?.record()
        recorder?.updateMeters()
    }
    func update() {
        recorder.updateMeters()
    }
    var decibels: Float {
        return recorder.averagePower(forChannel: 0)
    }
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recorder.stop()
        recorder.deleteRecording()
        recorder.prepareToRecord()
    }
}
