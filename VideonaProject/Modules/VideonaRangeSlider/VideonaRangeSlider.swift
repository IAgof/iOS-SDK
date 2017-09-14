//
//  VideonaRangeSlider.swift
//  VideonaRangeSlider
//
//  Created by Alejandro Arjonilla Garcia on 14/11/16.
//  Copyright © 2016 videona. All rights reserved.
//

import UIKit
import QuartzCore
import AVFoundation

@IBDesignable open class VideonaRangeSlider: UIControl {

    @IBInspectable open var lowerSliderImage: UIImage? {
        get {
            return lowerThumbLayer.image
        }
        set(lowerSliderImage) {
            lowerThumbLayer.image = lowerSliderImage
        }
    }

   @IBInspectable open var middleSliderImage: UIImage? {
        get {
            return middleThumbLayer.image
        }
        set(middleSliderImage) {
            middleThumbLayer.image = middleSliderImage
        }
    }

   @IBInspectable open var upperSliderImage: UIImage? {
        get {
            return upperThumbLayer.image
        }
        set(upperSliderImage) {
            upperThumbLayer.image = upperSliderImage
        }
    }

   @IBInspectable open var backgroundSliderColor: UIColor? {
        get {
            return sliderTintColor
        }
        set(backgroundSliderColor) {
            sliderTintColor = backgroundSliderColor!
        }
    }

   @IBInspectable open var middleSliderColor: UIColor? {
        get {
            return middleThumbTintColor
        }
        set(middleSliderColor) {
            middleThumbTintColor = middleSliderColor!
        }
    }

   @IBInspectable open var untrackedAreaColor: UIColor? {
        get {
            return untrackedAreaTintColor
        }
        set(untrackedAreaColor) {
            untrackedAreaTintColor = untrackedAreaColor!
        }
    }

   @IBInspectable open var untrackedAreaHeight: CGFloat = 0 {
        didSet {
            let height = min(untrackedAreaHeight, max(1, self.frame.height))
            let heightCenter = (self.frame.height - untrackedAreaHeight)  / 2

            backgoundLayerView?.frame = CGRect(x: 0, y: heightCenter, width: self.frame.width, height: height)
        }
    }

   @IBInspectable open var trackedAreaHeight: CGFloat = 0 {
        didSet {
            trackedAreaHeight = min(trackedAreaHeight, self.frame.height)
            trackLayer.height = trackedAreaHeight
        }
    }

    @IBInspectable open var thumbLayerHeight: CGFloat = 0

    @IBInspectable open var thumbLayerWidth: CGFloat = 0

    @IBInspectable open var middleThumbLayerHeight: CGFloat = 0

    @IBInspectable open var middleThumbLayerWidth: CGFloat = 0

    var thumbWidth: CGFloat {
        if let image = upperSliderImage {
            return image.size.width
        } else if thumbLayerWidth != 0 {
            return thumbLayerWidth
        } else {
            return 15
        }
    }

    var thumbHeight: CGFloat {
        if thumbLayerHeight != 0 {
            return thumbLayerHeight
        } else {
            return self.bounds.height + 10
        }
    }

    var middleThumbWidth: CGFloat {
        if let image = middleSliderImage {
            return image.size.width
        } else if middleThumbLayerWidth != 0 {
            return middleThumbLayerWidth
        } else {
            return 15
        }
    }

    var middleThumbHeight: CGFloat {
        if middleThumbLayerHeight != 0 {
            return middleThumbLayerHeight
        } else {
            return self.bounds.height + 10
        }
    }

    open var middleValue = 0.5 {
        didSet {
            self.updateLayerFrames()
        }
    }

    open var actualValue: Double {
        let middle = min(1, middleValue)
        return  middle * maximumValue
    }

    open var minimumValue: Double = 0.0 {
        didSet {
            self.updateLayerFrames()
        }
    }

    open var maximumValue: Double = 1.0 {
        didSet {
            self.updateLayerFrames()
        }
    }

    open var lowerValue: Double = 0.0 {
        didSet {
            self.updateLayerFrames()
        }
    }

    open var upperValue: Double = 1.0 {
        didSet {
            self.updateLayerFrames()
        }
    }

    open var rangeValue: Double! {

        return upperValue - lowerValue
    }

    open var videoAsset: AVAsset? {
        didSet {
            self.generateVideoImages()
        }
    }

    open var currentTime: Double {
        guard let duration = videoAsset?.duration.seconds else {
            return middleValue * rangeTime.seconds
        }
        return self.middleValue * duration
    }

    open var startTime: Double! {
        guard let duration = videoAsset?.duration.seconds else {
            return lowerValue * rangeTime.seconds
        }
        return lowerValue * duration
    }

    open var stopTime: Double! {
        guard let duration = videoAsset?.duration.seconds else {
            return upperValue * rangeTime.seconds
        }
        return upperValue * duration
    }

    open var rangeTime: CMTime = kCMTimeZero

    open var sliderTintColor = UIColor(red:0.97, green:0.71, blue:0.19, alpha:1.00) {
        didSet {
            self.lowerThumbLayer.backgroundColor = self.sliderTintColor.cgColor
            self.upperThumbLayer.backgroundColor = self.sliderTintColor.cgColor
        }
    }

    open var untrackedAreaTintColor = UIColor.black {
        didSet {
            backgoundLayerView?.backgroundColor = untrackedAreaTintColor
        }
    }

    open var middleThumbTintColor: UIColor! {
        didSet {
            self.middleThumbLayer.backgroundColor = self.middleThumbTintColor.cgColor
        }
    }

    open var delegate: VideonaRangeSliderDelegate?

    var middleThumbLayer = VideonaRangeSliderThumbLayer()
    var lowerThumbLayer = VideonaRangeSliderThumbLayer()
    var upperThumbLayer = VideonaRangeSliderThumbLayer()
    var trackLayer = VideonaRangeSliderTrackLayer()
    var previousLocation = CGPoint()

    var backgoundLayerView: UIView?

    open override var frame: CGRect {
        didSet {
            self.updateLayerFrames()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)!
        self.commonInit()
    }

    open override func layoutSubviews() {
        self.updateLayerFrames()
    }

    func commonInit() {
        self.trackLayer.rangeSlider = self
        self.middleThumbLayer.rangeSlider = self
        self.lowerThumbLayer.rangeSlider = self
        self.upperThumbLayer.rangeSlider = self

        self.layer.addSublayer(self.trackLayer)
        self.layer.addSublayer(self.middleThumbLayer)
        self.layer.addSublayer(self.lowerThumbLayer)
        self.layer.addSublayer(self.upperThumbLayer)

        self.middleThumbLayer.backgroundColor = UIColor.green.cgColor
        self.lowerThumbLayer.backgroundColor = self.sliderTintColor.cgColor
        self.upperThumbLayer.backgroundColor = self.sliderTintColor.cgColor

        self.trackLayer.contentsScale = UIScreen.main.scale
        self.lowerThumbLayer.contentsScale = UIScreen.main.scale
        self.upperThumbLayer.contentsScale = UIScreen.main.scale

        self.updateLayerFrames()

        backgoundLayerView = UIImageView(frame: CGRect(x: 0, y: 2, width: self.frame.width, height: (self.frame.height - 4)))
        backgoundLayerView?.backgroundColor = untrackedAreaTintColor
        backgoundLayerView?.contentMode = .scaleAspectFill
        backgoundLayerView?.clipsToBounds = true

        self.insertSubview(backgoundLayerView!, at:0)
    }

    func updateLayerFrames() {

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        self.trackLayer.frame = self.bounds

        self.trackLayer.setNeedsDisplay()

        setUntrackedAreaView()
        setMiddlePosition()
        setLowerPosition()
        setUpperPosition()

        CATransaction.commit()
    }

    func setUntrackedAreaView() {
        let height = min(untrackedAreaHeight, max(1, self.frame.height))
        let heightCenter = (self.frame.height - untrackedAreaHeight)  / 2

        backgoundLayerView?.frame = CGRect(x: 0, y: heightCenter, width: self.frame.width, height: height)
    }

    func setLowerPosition() {
        let lowerThumbCenter = CGFloat(self.positionForValue(self.lowerValue))

        if lowerSliderImage == nil {
            self.lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - self.thumbWidth / 2,
                                                y:(self.frame.height-middleThumbLayer.frame.height)/2,
                                                width: self.thumbWidth,
                                                height: self.thumbHeight)
        } else {
            let width = lowerSliderImage!.size.width
            let height = lowerSliderImage!.size.height
            let centerHeight = (self.frame.height - height) / 2

            self.lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - width / 2, y: centerHeight, width: width, height: height)
        }
    }

    func setMiddlePosition() {
        let middleThumbCenter = CGFloat(self.positionForValue(self.middleValue))

        if middleSliderImage == nil {
            self.middleThumbLayer.frame = CGRect(x: middleThumbCenter - self.thumbWidth / 2,
                                                 y:(self.frame.height-middleThumbLayer.frame.height)/2,
                                                 width: self.middleThumbWidth,
                                                 height: self.middleThumbHeight)
        } else {
            let width = middleSliderImage!.size.width
            let height = middleSliderImage!.size.height
            let centerHeight = (self.frame.height - height) / 2

            self.middleThumbLayer.frame = CGRect(x: middleThumbCenter - width / 2, y: centerHeight, width: width, height: height)
        }
    }

    func setUpperPosition() {
        let upperThumbCenter = CGFloat(self.positionForValue(self.upperValue))

        if upperSliderImage == nil {
            self.upperThumbLayer.frame = CGRect(x: upperThumbCenter - self.thumbWidth / 2,
                                                y:(self.frame.height-middleThumbLayer.frame.height)/2,
                                                width: self.thumbWidth,
                                                height: self.thumbHeight)
        } else {
            let width = upperSliderImage!.size.width
            let height = upperSliderImage!.size.height
            let centerHeight = (self.frame.height - height) / 2

            self.upperThumbLayer.frame = CGRect(x: upperThumbCenter - width / 2, y: centerHeight, width: width, height: height)
        }
    }

    func positionForValue(_ value: Double) -> Double {
        let position = Double(self.bounds.width - self.thumbWidth) * (value - self.minimumValue) / max(1, (self.maximumValue - self.minimumValue)) + Double(self.thumbWidth / 2.0)
        if position.isInfinite {
            return 0
        } else {
            return position
        }
    }

    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        self.previousLocation = touch.location(in: self)

        if self.lowerThumbLayer.frame.contains(self.previousLocation) {
            self.lowerThumbLayer.highlighted = true
            delegate?.rangeSliderLowerValueStartToChange()
        } else if self.upperThumbLayer.frame.contains(self.previousLocation) {
            self.upperThumbLayer.highlighted = true
            delegate?.rangeSliderUpperValueStartToChange()
//        } else {// if you want to select mid thumb on any touch on screen switch elses
        } else if self.middleThumbLayer.frame.contains(self.previousLocation) {
            self.middleThumbLayer.highlighted = true
        }

        return self.lowerThumbLayer.highlighted || self.upperThumbLayer.highlighted || self.middleThumbLayer.highlighted
    }

    func boundValue(_ value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }

    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)

        let deltaLocation = Double(location.x - self.previousLocation.x)
        let deltaValue = (self.maximumValue - self.minimumValue) * deltaLocation / Double(self.bounds.width - self.thumbWidth)
        let newMiddle = Double(self.previousLocation.x) * maximumValue / Double(self.bounds.width - self.thumbWidth)

        self.previousLocation = location

        if self.lowerThumbLayer.highlighted {
            if deltaValue > 0 && rangeValue <= 0.01 {

            } else {
                self.lowerValue += deltaValue
                self.lowerValue = self.boundValue(self.lowerValue, toLowerValue: self.minimumValue, upperValue: self.maximumValue)
                self.middleValue = self.boundValue(self.middleValue, toLowerValue: self.lowerValue, upperValue: self.upperValue)
                self.delegate?.rangeSliderLowerThumbValueChanged()
            }

        } else if self.middleThumbLayer.highlighted {
            self.middleValue = newMiddle
            self.middleValue = self.boundValue(self.middleValue, toLowerValue: self.lowerValue, upperValue: self.upperValue)
            self.delegate?.rangeSliderMiddleThumbValueChanged()
        } else if self.upperThumbLayer.highlighted {
            if deltaValue < 0 && rangeValue <= 0.01 {

            } else {
                self.upperValue += deltaValue
                self.upperValue = self.boundValue(self.upperValue, toLowerValue: self.minimumValue, upperValue: self.maximumValue)
                self.middleValue = self.boundValue(self.middleValue, toLowerValue: self.lowerValue, upperValue: self.upperValue)

                self.delegate?.rangeSliderUpperThumbValueChanged()
            }
        }

        self.sendActions(for: .valueChanged)
        return true
    }

    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if self.lowerThumbLayer.highlighted {
            delegate?.rangeSliderLowerValueStopToChange()
            self.lowerThumbLayer.highlighted = false
        }
        if self.upperThumbLayer.highlighted {
            delegate?.rangeSliderUpperValueStopToChange()
            self.upperThumbLayer.highlighted = false
        }

        if self.middleThumbLayer.highlighted {
            self.middleThumbLayer.highlighted = false
        }
    }

    func generateVideoImages() {
        DispatchQueue.main.async(execute: {

            self.lowerValue = 0.0
            self.upperValue = 1.0

            for subview in self.subviews {
                if subview is UIImageView {
                    subview.removeFromSuperview()
                }
            }

            let imageGenerator = AVAssetImageGenerator(asset: self.videoAsset!)

            let assetDuration = CMTimeGetSeconds(self.videoAsset!.duration)
            var Times = [NSValue]()

            let numberOfImages = Int((self.frame.width / self.frame.height))

            for index in 1...numberOfImages {
                let point = CMTimeMakeWithSeconds(assetDuration/Double(index), 600)
                Times += [NSValue(time: point)]
            }

            Times = Times.reversed()

            let imageWidth = self.frame.width/CGFloat(numberOfImages)
            var imageFrame = CGRect(x: 0, y: 2, width: imageWidth, height: self.frame.height-4)

            imageGenerator.generateCGImagesAsynchronously(forTimes: Times) { (_, image, _, result, error) in
                if error == nil {

                    if result == AVAssetImageGeneratorResult.succeeded {

                        DispatchQueue.main.async(execute: {
                            let imageView = UIImageView(image: UIImage(cgImage: image!))
                            imageView.contentMode = .scaleAspectFill
                            imageView.clipsToBounds = true
                            imageView.frame = imageFrame
                            imageFrame.origin.x += imageWidth
                            self.insertSubview(imageView, at:1)
                        })
                    }

                    if result == AVAssetImageGeneratorResult.failed {
                        print("Generating Fail")
                    }

                } else {
                    print("Error at generating images : \(error!.localizedDescription)")
                }
            }

        })

    }

}
