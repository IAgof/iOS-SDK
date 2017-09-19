//
//  PlayerView.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 13/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import TTRangeSlider

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

@IBDesignable open class PlayerView: UIView, PlayerDelegate {
    // MARK: - VIPER
    var eventHandler: PlayerPresenterInterface?
    var delegate: PlayerViewDelegate?
    var state: PlayerViewFinishedDelegate?

    // MARK: - Variables
    public var player: AVPlayer = AVPlayer()
    var playerLayer: AVPlayerLayer?
    var movieComposition: AVMutableComposition!
    var audioMix: AVAudioMix?
    var videoComposition: AVMutableVideoComposition?
    var oldSliderValue: Float = 0.0

    // MARK: - Outlets
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
        }
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        seekSlider.numberFormatterOverride = ElapsedTimeFormatter()
        seekSlider.delegate = self
    }

    open class func instanceFromNib() -> UIView {
        let view = UINib(nibName: "PlayerView", bundle: Bundle(for: PlayerView.self)).instantiate(withOwner: nil, options: nil)[0] as! UIView
        return view
    }

    open func setPlayerMovieComposition(_ composition: AVMutableComposition) {
        self.movieComposition = composition
    }

    open func setPlayerAudioMix(_ audioMix: AVAudioMix) {
        self.audioMix = audioMix
    }

    open func setPlayerVideoComposition(_ videoComposition: AVMutableVideoComposition) {
        self.videoComposition = videoComposition

        if let playerItem = self.player.currentItem { playerItem.videoComposition = videoComposition }
    }

    override open func layoutSubviews() {
        self.eventHandler?.layoutSubViews()
    }

    open func updateLayers() {
        self.superview?.layoutIfNeeded()
        let superViewFrame = (self.superview?.frame)!
        self.frame = CGRect(x: 0, y: 0, width: superViewFrame.width, height: superViewFrame.height)

        if (playerLayer != nil) {
            playerLayer!.frame = CGRect(x: 0, y: 0, width: superViewFrame.width, height: superViewFrame.width*9/16)
            self.playerContainer.frame = CGRect(x: 0, y: 0, width: superViewFrame.width, height: superViewFrame.width*9/16)
        }
    }

    open func getView() -> UIView {
        return self
    }

    open func removeSubviews() {
        if let sublayers = self.playerContainer.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
    }

    func disablePlayAndSeekBar() {
        //TODO: Remove all interactions on play button and seekbar?
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
        if (movieComposition != nil) {
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
    }

    func setUpVideoPlayer(withPlayerItem playerItem: AVPlayerItem) {
		
        if player.currentItem == nil {
			
			let player = AVPlayer.init(playerItem: playerItem)

            player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1000), queue: DispatchQueue.main) { _ in
                if self.player.currentItem?.status == .readyToPlay && (self.player.rate != 0) && (self.player.error == nil) {//Playing
                    self.eventHandler?.updateSeekBar()
                    guard let time = self.player.currentItem?.asset.duration.seconds else {return}
                    self.actualSliderValueLabel.text = "\(self.timeToStringInMinutesAndseconds(time))"
                }
            }

            playerLayer = AVPlayerLayer(player: player)
            playerLayer!.frame = playerContainer.frame

            self.playerContainer.layoutIfNeeded()
            self.playerContainer.layer.addSublayer(playerLayer!)
            self.playerContainer.bringSubview(toFront: seekSlider)
            self.playerContainer.bringSubview(toFront: playOrPauseButton)
            addSwipeGesture()

        } else {
            player.replaceCurrentItem(with: playerItem)
        }

        guard let time = self.player.currentItem?.asset.duration.seconds else {return}
        self.actualSliderValueLabel.text = "\(self.timeToStringInMinutesAndseconds(time))"
        if !playerItem.duration.seconds.isNaN {
            self.seekSlider.maxValue = Float(playerItem.duration.seconds)
        }
        self.seekToTime(0.05)

        state?.playerHasLoaded()
    }

    func addSwipeGesture() {
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        self.playerContainer.addGestureRecognizer(swipe)
    }

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UIPanGestureRecognizer {
            let velocity = swipeGesture.velocity(in: playerContainer)
            debugPrint(velocity)
            let actualTime = player.currentTime()
			guard let maxTime = player.currentItem?.duration.seconds else {return}
			
			var timeSeekTo = Float(actualTime.seconds) + Float(velocity.x/100)
			
			if timeSeekTo > Float(maxTime) {
				timeSeekTo = timeSeekTo - Float(maxTime)
			} else if timeSeekTo < 0 {
				timeSeekTo = Float(maxTime) - timeSeekTo
			}
			
			self.seekToTime(timeSeekTo)
			self.state?.playerSeeksTo(timeSeekTo)
			self.delegate?.seekBarUpdate(timeSeekTo)
        }
    }

    open func createVideoPlayerByPath(_ videoURL: URL) {
            let asset = AVAsset(url: videoURL)
            let playerItem: AVPlayerItem = AVPlayerItem(asset: asset)
            setUpVideoPlayer(withPlayerItem: playerItem)

            self.seekToTime(0)

            state?.playerHasLoaded()
    }

    open func updateSeekBarOnUI() {
        guard (player.currentItem?.duration.seconds) != nil else {
            return
        }
        let currentTime = player.currentTime().seconds
        let sliderValue = Float((currentTime))

        self.seekSlider.selectedMaximum = Float(currentTime)
        if oldSliderValue != sliderValue {
            self.delegate?.seekBarUpdate(sliderValue)
        }
        oldSliderValue = sliderValue
    }

    open func setViewPlayerTappable() {
        if singleFingerTap == nil {
            singleFingerTap = UITapGestureRecognizer.init(target: self, action:#selector(PlayerView.videoPlayerViewTapped))
            playerContainer.addGestureRecognizer(singleFingerTap!)
        }
    }

    open func videoPlayerViewTapped() {
        eventHandler?.videoPlayerViewTapped()
    }

    @IBAction open func pushPlayButton(_ sender: AnyObject) {
        eventHandler?.pushPlayButton()
    }

    open func sliderBeganTracking() {
        playerRateBeforeSeek = player.rate
        player.pause()
    }

    open func sliderEndedTracking() {

    }

    open func sliderValueChanged() {
        let timeToGo = CMTimeMakeWithSeconds(Float64(seekSlider.selectedMaximum), 1000)
        let tolerance = CMTimeMake(1, 100)

        player.seek(to: timeToGo, toleranceBefore: tolerance, toleranceAfter: tolerance, completionHandler: {
            completed in
            if (self.playerRateBeforeSeek > 0) {
                self.player.play()
            }

            if completed {
                self.delegate?.seekBarUpdate(Float(self.seekSlider.selectedMaximum))

                if (self.player.currentItem?.duration.seconds) != nil {
                    self.state?.playerSeeksTo(Float(self.seekSlider.selectedMaximum))
                }
            }
        })
    }

    open func setUpVideoFinished() {
        DispatchQueue.main.async(execute: { () -> Void in
            #if DEBUG
                print("Set up video finished")
            #endif

            self.player.pause()
            self.player.currentItem?.seek(to: CMTime.init(value: 0, timescale: 10))
            self.state?.playerSeeksTo(0)
        })
    }

    open func onVideoStops() {
        eventHandler?.onVideoStops()
    }

    open func pauseVideoPlayer() {
		player.pause()
        state?.playerPause()

        #if DEBUG
            print("Video has stopped")
        #endif
    }

    open func playVideoPlayer() {
		player.play()
        state?.playerStartsToPlay()

        //Start timer

        #if DEBUG
            print("Playing video")
        #endif

    }

    open func seekToTime(_ time: Float) {
//        print("Seek to time manually to --\(time)")

        if !player.currentItem!.duration.isIndefinite {
            let timeToGo = CMTimeMakeWithSeconds(Double(time), 1000)
            let tolerance = CMTimeMake(1, 100)
            player.seek(to: timeToGo, toleranceBefore: tolerance, toleranceAfter: tolerance)
            self.seekSlider.selectedMaximum = time
        }
    }

    open func setAVSyncLayer(_ layer: CALayer) {
        print("Animated layer frame: \(layer.frame)")

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
        self.player.currentItem?.audioMix = value
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
        player.volume = level
    }

    open func setPlayerMuted(_ state: Bool) {
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
        self.player.pause()
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        player.replaceCurrentItem(with: nil)
    }

    func addFinishObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onVideoStops),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
    }
    open func removeFinishObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    public func setTimeLabels(isHidden state: Bool) {
            //TODO: Update seekbar timer with new seekbar?
        //actualSliderValueLabel.isHidden = state
    }
}

extension PlayerView: TTRangeSliderDelegate {
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
