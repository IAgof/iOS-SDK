//
//  VideonaPlayer.swift
//
//  Created by Alejandro Arjonilla Garcia on 4/10/17.
//

import Foundation
import UIKit
import AVFoundation
import TTRangeSlider
import AVKit

public enum VideonaPlayerNotifications {
    case seekBarUpdate(value: Float)
    case playerStartsToPlay
    case playerHasLoaded
    case playerPause
    case onVideoStops
    
    public var notificationName: String{
        switch self {
        case .seekBarUpdate: return "seekBarUpdateNotification"
        case .playerStartsToPlay: return "playerStartsToPlayNotification"
        case .playerHasLoaded: return "playerHasLoadedNotification"
        case .playerPause: return "playerPauseNotification"
        case .onVideoStops: return "onVideoStops"
        }
    }
    
    public func postNotification(){
        switch self {
        case .seekBarUpdate(let value):
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.notificationName) , object: value)
        default:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.notificationName) , object: nil)
        }
    }
}

private class ElapsedTimeFormatter: NumberFormatter {
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        return dateFormatter
    }()
    
    override func string(from number: NSNumber) -> String? {
        let timeInterval = TimeInterval(number)
        return dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: timeInterval))
    }
}

public protocol VideonaPlayerInterface {
    var isPlaying: Bool {get set}
    func createVideoPlayer()
    func createVideoPlayerByPath(_ videoURL: URL)
    func setPlayerMovieComposition(_ composition: AVMutableComposition)
    func setPlayerAudioMix(_ audioMix: AVAudioMix)
    func setPlayerVideoComposition(_ videoComposition: AVMutableVideoComposition)
    func setUpVideoFinished()
    func pauseVideoPlayer()
    func playVideoPlayer()
    func seekToTime(_ time: Float)
    func setPlayerVolume(_ level: Float)
    func setPlayerMuted(_ state: Bool)
    
    func disableSliderAndInteractions()
    func enableSliderAndInteractions()
    
    func setAVSyncLayer(_ layer: CALayer)
    func removeAVSyncLayers()
    func setAudioMix(audioMix value: AVAudioMix)
    
    func removeAudioMix()
    func removeVideoComposition()
    func removeFinishObserver()
    func removePlayer()
    func setTimeLabels(isHidden state: Bool)
}

@IBDesignable public class VideonaPlayerView: UIView, VideonaPlayerInterface {
    // MARK: - Variables
    public var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    public var movieComposition: AVMutableComposition = AVMutableComposition()
    public var audioMix: AVAudioMix?
    public var videoComposition: AVMutableVideoComposition?
    var oldSliderValue: Float = 0.0
    
    // MARK: - Outlets
    @IBOutlet weak public var contentView: UIView!
    @IBOutlet weak public var playOrPauseButton: UIButton!
    @IBOutlet weak var playerContainer: UIView!
    @IBOutlet weak var seekSlider: TTRangeSlider!
    @IBOutlet weak var actualSliderValueLabel: UILabel!
    
    public var seekBarColor: UIColor = .red {
        didSet {
            seekSlider.tintColor = seekBarColor
            seekSlider.tintColorBetweenHandles = seekBarColor
            seekSlider.handleColor = seekBarColor
        }
    }
    
    public var seekBarTextColor: UIColor = .lightGray {
        didSet {
            seekSlider.maxLabelColour = seekBarTextColor
        }
    }
    
    var playerRateBeforeSeek: Float = 0
    var isPlayerMuted = false
    var singleFingerTap: UITapGestureRecognizer?
    
    public var isPlaying: Bool = false {
        didSet {
            self.bringSubview(toFront: playOrPauseButton)
            self.playOrPauseButton.setImage( self.isPlaying ? #imageLiteral(resourceName: "pausePlayerIcon"):#imageLiteral(resourceName: "playPlayerIcon"), for: .normal)
            isPlaying ? playVideoPlayer() : pauseVideoPlayer()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    func setupView(){
        let bundle = Bundle(for: VideonaPlayerView.self)
        bundle.loadNibNamed("VideonaPlayerView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        createVideoPlayer()
        seekSlider.numberFormatterOverride = ElapsedTimeFormatter()
        seekSlider.delegate = self
    }
    public func registerNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.onVideoStops), name: NSNotification.Name(rawValue: VideonaPlayerNotifications.onVideoStops.notificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.seekToTimeNotification(_:)), name: NSNotification.Name(rawValue: VideonaPlayerNotifications.seekBarUpdate(value: 0).notificationName), object: nil)
    }
    public func removeNotifications(){
        NotificationCenter.default.removeObserver(self)
    }
    open func setPlayerMovieComposition(_ composition: AVMutableComposition) {
        self.movieComposition = composition
    }
    
    open func setPlayerAudioMix(_ audioMix: AVAudioMix) {
        self.audioMix = audioMix
    }
    
    open func setPlayerVideoComposition(_ videoComposition: AVMutableVideoComposition) {
        self.videoComposition = videoComposition
        
        if let playerItem = self.player?.currentItem { playerItem.videoComposition = videoComposition }
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.playerContainer.frame
    }
    func disablePlayAndSeekBar() {
        playOrPauseButton.isHidden = true
        playOrPauseButton.isEnabled = false
        
        seekSlider.isHidden = true
        seekSlider.isEnabled = false
        
        self.playerContainer.sendSubview(toBack: playOrPauseButton)
        self.playerContainer.sendSubview(toBack: seekSlider)
    }
    
    // MARK: - Player Interface
    open func createVideoPlayer() {
        self.setViewPlayerTappable()
        let playerItem: AVPlayerItem = AVPlayerItem(asset: movieComposition)
        
        if audioMix != nil {
            playerItem.audioMix = audioMix
        }
        if videoComposition != nil {
            playerItem.videoComposition = videoComposition
        }
        setUpVideoPlayer(withPlayerItem: playerItem)
        
        addFinishObserver()
        //            self.disablePlayAndSeekBar()
    }
    
    func setUpVideoPlayer(withPlayerItem playerItem: AVPlayerItem) {
        
        if player == nil {
            player = AVPlayer.init(playerItem: playerItem)
            player!.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1000), queue: DispatchQueue.main) { _ in
                if self.player!.currentItem?.status == .readyToPlay && (self.player!.rate != 0) && (self.player!.error == nil) {//Playing
                    self.updateSeekBarOnUI()
                    guard let time = self.player?.currentItem?.asset.duration.seconds else {return}
                    self.actualSliderValueLabel.text = "\(self.timeToStringInMinutesAndseconds(time))"
                }
            }
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = playerContainer.frame
            self.playerContainer.layer.addSublayer(playerLayer!)
            addSwipeGesture()
        } else {
            player?.replaceCurrentItem(with: playerItem)
        }
        
        guard let time = self.player?.currentItem?.asset.duration.seconds else {return}
        self.actualSliderValueLabel.text = "\(self.timeToStringInMinutesAndseconds(time))"
        if !playerItem.duration.seconds.isNaN {
            self.seekSlider.maxValue = Float(playerItem.duration.seconds)
        }
        self.seekToTime(0.05)
        VideonaPlayerNotifications.playerHasLoaded.postNotification()
    }
    
    func addSwipeGesture() {
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        self.playerContainer.addGestureRecognizer(swipe)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UIPanGestureRecognizer {
            let velocity = swipeGesture.velocity(in: playerContainer)
            debugPrint(velocity)
            if let actualTime = player?.currentTime() {
                guard let maxTime = player?.currentItem?.duration.seconds else {return}
                
                var timeSeekTo = Float(actualTime.seconds) + Float(velocity.x/100)
                
                if timeSeekTo > Float(maxTime) {
                    timeSeekTo = timeSeekTo - Float(maxTime)
                } else if timeSeekTo < 0 {
                    timeSeekTo = Float(maxTime) - timeSeekTo
                }
                
                self.seekToTime(timeSeekTo)
                VideonaPlayerNotifications.seekBarUpdate(value: timeSeekTo).postNotification()
            }
        }
    }
    
    open func createVideoPlayerByPath(_ videoURL: URL) {
        let asset = AVAsset(url: videoURL)
        let playerItem: AVPlayerItem = AVPlayerItem(asset: asset)
        setUpVideoPlayer(withPlayerItem: playerItem)
        self.seekToTime(0)
        VideonaPlayerNotifications.playerHasLoaded.postNotification()
    }
    
    open func updateSeekBarOnUI() {
        guard (player?.currentItem?.duration.seconds) != nil ,
            let currentTime = player?.currentTime().seconds else {
                return
        }
        let sliderValue = Float((currentTime))
        
        self.seekSlider.selectedMaximum = Float(currentTime)
        if oldSliderValue != sliderValue {
            VideonaPlayerNotifications.seekBarUpdate(value: sliderValue).postNotification()
        }
        oldSliderValue = sliderValue
    }
    
    open func setViewPlayerTappable() {
        if singleFingerTap == nil {
            singleFingerTap = UITapGestureRecognizer.init(target: self, action:#selector(VideonaPlayerView.videoPlayerViewTapped))
            playerContainer.addGestureRecognizer(singleFingerTap!)
        }
    }
    
    open func videoPlayerViewTapped() {
        isPlaying = !isPlaying
    }
    
    @IBAction open func pushPlayButton(_ sender: AnyObject) {
        isPlaying = !isPlaying
    }
    @IBAction func pushExpandButton(_ sender: Any) {
        guard let parentController = parentViewController else { return }
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(playerItem: self.player?.currentItem)
        playerViewController.player = player
        
        parentViewController?.present(playerViewController, animated: true, completion: nil)
    }
    open func sliderBeganTracking() {
        playerRateBeforeSeek = player!.rate
        player!.pause()
    }
    
    open func sliderEndedTracking() {
        
    }
    
    open func sliderValueChanged() {
        let timeToGo = CMTimeMakeWithSeconds(Float64(seekSlider.selectedMaximum), 1000)
        let tolerance = CMTimeMake(1, 100)
        
        player?.seek(to: timeToGo, toleranceBefore: tolerance, toleranceAfter: tolerance, completionHandler: {
            completed in
            if (self.playerRateBeforeSeek > 0) {
                self.player!.play()
            }
            
            if completed {
                VideonaPlayerNotifications.seekBarUpdate(value: Float(self.seekSlider.selectedMaximum)).postNotification()
                if (self.player?.currentItem?.duration.seconds) != nil {
                    VideonaPlayerNotifications.seekBarUpdate(value: 0).postNotification()
                }
            }
        })
    }
    
    open func setUpVideoFinished() {
        DispatchQueue.main.async(execute: { () -> Void in
            #if DEBUG
                print("Set up video finished")
            #endif
            
            self.player?.pause()
            self.player?.currentItem?.seek(to: CMTime.init(value: 0, timescale: 10))
            VideonaPlayerNotifications.seekBarUpdate(value: 0).postNotification()
        })
    }
    
    open func onVideoStops() {
        isPlaying = false
        setUpVideoFinished()
    }
    
    open func pauseVideoPlayer() {
        guard let player = self.player else {
            return
        }
        player.pause()
        VideonaPlayerNotifications.playerPause.postNotification()
        print("Video has stopped")
    }
    
    open func playVideoPlayer() {
        guard let player = self.player else {
            return
        }
        player.play()
        VideonaPlayerNotifications.playerStartsToPlay.postNotification()
    }
    @objc private func seekToTimeNotification(_ notification: Notification) {
        guard let time = notification.object as? Float else { return }
        self.seekToTime(time)
    }
    open func seekToTime(_ time: Float) {
        //        print("Seek to time manually to --\(time)")
        
        guard let player = self.player else {
            return
        }
        if !player.currentItem!.duration.isIndefinite {
            let timeToGo = CMTimeMakeWithSeconds(Double(time), 1000)
            let tolerance = CMTimeMake(1, 100)
            player.seek(to: timeToGo, toleranceBefore: tolerance, toleranceAfter: tolerance)
            self.seekSlider.selectedMaximum = time
        }
    }
    
    open func setAVSyncLayer(_ layer: CALayer) {
        print("Animated layer frame: \(layer.frame)")
        
        guard let player = self.player else {
            return
        }
        guard let currentItem = player.currentItem else {return}
        let newLayer = layer
        
        newLayer.frame = (playerLayer?.frame)!
        if layer.sublayers != nil {
            for sublayer in layer.sublayers! {
                sublayer.frame = (playerLayer?.frame)!
            }
        }
        
        let avLayer = AVSynchronizedLayer(playerItem: currentItem)
        avLayer.addSublayer(newLayer)
        
        guard let pLayer = playerLayer else {return}
        avLayer.frame = pLayer.frame
        
        print("Animated layer frame after change: \(layer.frame)")
        print("player layer frame: \(layer.frame)")
        playerLayer?.addSublayer(avLayer)
    }
    
    open func removeAVSyncLayers() {
        guard let pLayer = playerLayer else {return}
        guard let sublayers = pLayer.sublayers else {return }
        
        let layers = Array(sublayers[1..<sublayers.count])
        
        for layer in  layers {
            layer.removeFromSuperlayer()
        }
    }
    
    public func setAudioMix(audioMix value: AVAudioMix) {
        self.player?.currentItem?.audioMix = value
    }
    
    func timeToStringInMinutesAndseconds(_ time: Double) -> String {
        let mins = Int(floor(time.truncatingRemainder(dividingBy: 3600)) / 60)
        var secs = Int(floor(time.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60))
        
        if secs < 0 {
            secs = 0
        }
        
        return String(format:"%02d:%02d", mins, secs)
    }
    
    open func setPlayerVolume(_ level: Float) {
        guard let player = self.player else {
            return
        }
        player.volume = level
    }
    
    open func setPlayerMuted(_ state: Bool) {
        guard let player = self.player else {
            return
        }
        isPlayerMuted = state
        player.isMuted = isPlayerMuted
    }
    
    open func disableSliderAndInteractions() {
        seekSlider.isHidden = true
        seekSlider.isEnabled = false
        singleFingerTap?.isEnabled = false
        playOrPauseButton.isEnabled = false
    }
    
    open func enableSliderAndInteractions() {
        seekSlider.isEnabled = true
        singleFingerTap?.isEnabled = true
        playOrPauseButton.isEnabled = true
    }
    
    open func removeAudioMix() {
        audioMix = nil
    }
    
    open func removeVideoComposition() {
        videoComposition = nil
    }
    
    public func removePlayer() {
        self.player?.pause()
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        self.player = nil
    }
    
    func addFinishObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onVideoStops),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }
    open func removeFinishObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func setTimeLabels(isHidden state: Bool) {
        //TODO: Update seekbar timer with new seekbar?
        //actualSliderValueLabel.isHidden = state
    }
}

extension VideonaPlayerView: TTRangeSliderDelegate {
    public func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        sliderValueChanged()
    }
    
    public func didStartTouches(in sender: TTRangeSlider!) {
        sliderBeganTracking()
    }
    
    public func didEndTouches(in sender: TTRangeSlider!) {
        sliderEndedTracking()
    }
}

