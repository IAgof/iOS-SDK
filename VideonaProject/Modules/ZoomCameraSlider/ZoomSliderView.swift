//
//  ZoomSliderView.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

public protocol ZoomSliderDelegate {
    func zoomLevelChange(_ value: Float)
}

@IBDesignable open class ZoomSliderView: UIView {
    // MARK: - VIPER
    var eventHandler: ZoomSliderPresenterInterface?
    open var delegate: ZoomSliderDelegate?

    // Our custom view from the XIB file
    var view: UIView!

    @IBOutlet weak var zoomSlider: UISlider!
    @IBOutlet weak var zoomButtonUp: UIButton!
    @IBOutlet weak var zoomButtonDown: UIButton!

    var longPressGesture: UILongPressGestureRecognizer?

    @IBInspectable var lowerValueImage: UIImage? {
        get {
            return zoomSlider.minimumValueImage
        }
        set(lowerValueImage) {
            zoomSlider.minimumValueImage = lowerValueImage
            rotateLabelsSlider()
        }
    }

    @IBInspectable var upperValueImage: UIImage? {
        get {
            return zoomSlider.maximumValueImage
        }
        set(upperValueImage) {
            zoomSlider.maximumValueImage = upperValueImage
            rotateLabelsSlider()
        }
    }

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        // 1. setup any properties here
        // 2. call super.init(frame:)
        super.init(frame: frame)
        eventHandler = ZoomSliderPresenter(controller: self)

        // 3. Setup view from .xib file
        xibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here

        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        eventHandler = ZoomSliderPresenter(controller: self)

        // 3. Setup view from .xib file
        xibSetup()
    }

    func xibSetup() {
        view = loadViewFromNib()

        // use bounds not frame or it'll be offset
        view.frame = bounds

        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]

        view.layer.cornerRadius = 4

        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: ZoomSliderView.self)

        let nib = UINib(nibName: "ZoomSliderView", bundle: bundle)

        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    override open func awakeFromNib() {
        super.awakeFromNib()

        let zoomUpTapGesture = UITapGestureRecognizer(target: self, action: #selector(zoomUp(_:)))
        let zoomUpLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(zoomUp(_:)))
        let zoomDownTapGesture = UITapGestureRecognizer(target: self, action: #selector(zoomDown(_:)))
        let zoomDownLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(zoomDown(_:)))

        zoomButtonUp.addGestureRecognizer(zoomUpTapGesture)
        zoomButtonUp.addGestureRecognizer(zoomUpLongGesture)
        zoomButtonDown.addGestureRecognizer(zoomDownTapGesture)
        zoomButtonDown.addGestureRecognizer(zoomDownLongGesture)
    }

    open func rotateLabelsSlider() {
        guard let slider = zoomSlider else {return}

        guard let minimumImage = slider.minimumValueImage else {return}
        let minImage = UIImage(cgImage: minimumImage.cgImage!, scale: slider.minimumValueImage!.scale, orientation: .right)
        slider.minimumValueImage = minImage

        guard let maximumImage = slider.maximumValueImage else {return}
        let maxImage = UIImage(cgImage: maximumImage.cgImage!, scale: slider.maximumValueImage!.scale, orientation: .right)
        slider.maximumValueImage = maxImage
    }
}

import AVFoundation
extension ZoomSliderView {
    @IBAction func sliderValueChanged(_ sender: AnyObject) {
        eventHandler?.sliderValueHasChangedTo(zoomSlider.value)
    }

    public func setZoomSliderValue(_ value: Float) {
        zoomSlider.value = value
    }

    public func setZoomWithPinchValues(_ scale: CGFloat,
                                       velocity: CGFloat) {
        eventHandler?.setZoomWithPinch(scale,
                                       velocity: velocity)
    }
    public func setDefaultZoom(_ value: Float) {
        eventHandler?.sliderValueHasChangedTo(value)
        zoomSlider.value = value
    }

    func zoomUp(_ sender: UIGestureRecognizer) {
        if zoomSlider.value < 10 {
            eventHandler?.sliderValueHasChangedTo(zoomSlider.value + 0.5)
            zoomSlider.value = zoomSlider.value + 0.5
        }
    }

    func zoomDown(_ sender: UIGestureRecognizer) {
        if zoomSlider.value > 1 {
            eventHandler?.sliderValueHasChangedTo(zoomSlider.value - 0.5)
            zoomSlider.value = zoomSlider.value - 0.5
        }
    }
}

extension ZoomSliderView:ZoomSliderPresenterDelegate {
    func updateSliderValue(_ value: Float) {
        zoomSlider.value = value
    }
}
