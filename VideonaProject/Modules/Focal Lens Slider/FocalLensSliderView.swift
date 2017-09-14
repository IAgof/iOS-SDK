//
//  FocalLensSliderView.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

public protocol FocalLensSliderDelegate {
    func audioLevelChange(_ value: Float)
}

@IBDesignable open class FocalLensSliderView: UIView, FocalLensSliderPresenterDelegate {
    // MARK: - VIPER
    var eventHandler: FocalLensSliderPresenterInterface?
    open var delegate: FocalLensSliderDelegate?

    // Our custom view from the XIB file
    var view: UIView!

    @IBOutlet weak var focalLensSlider: UISlider!

    @IBInspectable var lowerValueImage: UIImage? {
        get {
            return focalLensSlider.minimumValueImage
        }
        set(lowerValueImage) {
            focalLensSlider.minimumValueImage = lowerValueImage
            rotateLabelsSlider()
        }
    }

    @IBInspectable var upperValueImage: UIImage? {
        get {
            return focalLensSlider.maximumValueImage
        }
        set(upperValueImage) {
            focalLensSlider.maximumValueImage = upperValueImage
            rotateLabelsSlider()
        }
    }

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        // 1. setup any properties here
        // 2. call super.init(frame:)
        super.init(frame: frame)
        eventHandler = FocalLensSliderPresenter(controller: self)

        // 3. Setup view from .xib file
        xibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here

        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        eventHandler = FocalLensSliderPresenter(controller: self)

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
        let bundle = Bundle(for: FocalLensSliderView.self)

        let nib = UINib(nibName: "FocalLensSliderView", bundle: bundle)

        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    open func rotateLabelsSlider() {
        guard let slider = focalLensSlider else {return}

        guard let minimumImage = slider.minimumValueImage else {return}
        let minImage = UIImage(cgImage: minimumImage.cgImage!, scale: slider.minimumValueImage!.scale, orientation: .right)
        slider.minimumValueImage = minImage

        guard let maximumImage = slider.maximumValueImage else {return}
        let maxImage = UIImage(cgImage: maximumImage.cgImage!, scale: slider.maximumValueImage!.scale, orientation: .right)
        slider.maximumValueImage = maxImage
    }

    open override func awakeFromNib() {
        rotateImagesSlider()
    }

    open func rotateImagesSlider() {
        guard let slider = focalLensSlider else {return}

        let minImage = UIImage(cgImage: slider.minimumValueImage!.cgImage!, scale: slider.minimumValueImage!.scale, orientation: .right)
        let maxImage = UIImage(cgImage: slider.maximumValueImage!.cgImage!, scale: slider.maximumValueImage!.scale, orientation: .right)

        slider.minimumValueImage = minImage
        slider.maximumValueImage = maxImage

    }

}

import AVFoundation
extension FocalLensSliderView {

    @IBAction func sliderValueChanged(_ sender: AnyObject) {
        eventHandler?.sliderValueHasChangedTo(focalLensSlider.value)
    }
}
