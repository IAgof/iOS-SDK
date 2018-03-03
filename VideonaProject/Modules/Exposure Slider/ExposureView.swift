//
//  ExposureView.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

public protocol ExposureDelegate {
    func closeWhiteBalancePushed()
}

@IBDesignable open class ExposureView: UIView, ExposurePresenterDelegate {
    // MARK: - VIPER
    var eventHandler: ExposurePresenterInterface?
    open var delegate: ExposureDelegate?

    @IBOutlet weak var exposureSlider: UISlider!

    @IBInspectable var lowerValueImage: UIImage? {
        get {
            return exposureSlider.minimumValueImage
        }
        set(lowerValueImage) {
            exposureSlider.minimumValueImage = lowerValueImage
            rotateLabelsSlider()
        }
    }

    @IBInspectable var upperValueImage: UIImage? {
        get {
            return exposureSlider.maximumValueImage
        }
        set(upperValueImage) {
            exposureSlider.maximumValueImage = upperValueImage
            rotateLabelsSlider()
        }
    }

    // Our custom view from the XIB file
    var view: UIView!

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        // 1. setup any properties here

        // 2. call super.init(frame:)
        super.init(frame: frame)
        eventHandler = ExposurePresenter(controller: self)

        // 3. Setup view from .xib file
        xibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here

        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        eventHandler = ExposurePresenter(controller: self)

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
        let bundle = Bundle(for: ExposureView.self)

        let nib = UINib(nibName: "ExposureView", bundle: bundle)

        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    open func rotateLabelsSlider() {
        guard let slider = exposureSlider else {return}

        guard let minimumImage = slider.minimumValueImage else {return}
        let minImage = UIImage(cgImage: minimumImage.cgImage!, scale: slider.minimumValueImage!.scale, orientation: .right)
        slider.minimumValueImage = minImage

        guard let maximumImage = slider.maximumValueImage else {return}
        let maxImage = UIImage(cgImage: maximumImage.cgImage!, scale: slider.maximumValueImage!.scale, orientation: .right)
        slider.maximumValueImage = maxImage
    }

    // MARK: - Actions
    @IBAction func exposureSliderValueChanged(_ sender: AnyObject) {
        eventHandler?.exposureValueChanged(exposureSlider.value)
    }
    
    public func setDefaultExposure() {
        exposureSlider.value = 0.5
    }
}
