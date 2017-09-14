//
//  InputSoundGainControlView.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

@IBDesignable open class InputSoundGainControlView: UIView {
    // MARK: - VIPER
    var eventHandler: InputSoundGainControlPresenterInterface?

    // Our custom view from the XIB file
    var view: UIView!

    @IBOutlet weak var gainControlSlider: UISlider!

    @IBInspectable var lowerValueImage: UIImage? {
        get {
            return gainControlSlider.minimumValueImage
        }
        set(lowerValueImage) {
            gainControlSlider.minimumValueImage = lowerValueImage
            rotateLabelsSlider()
        }
    }

    @IBInspectable var upperValueImage: UIImage? {
        get {
            return gainControlSlider.maximumValueImage
        }
        set(upperValueImage) {
            gainControlSlider.maximumValueImage = upperValueImage
            rotateLabelsSlider()
        }
    }

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        // 1. setup any properties here
        // 2. call super.init(frame:)
        super.init(frame: frame)
        eventHandler = InputSoundGainControlPresenter()

        // 3. Setup view from .xib file
        xibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here

        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        eventHandler = InputSoundGainControlPresenter()

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
        let bundle = Bundle(for: InputSoundGainControlView.self)

        let nib = UINib(nibName: "InputSoundGainControlView", bundle: bundle)

        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    open func rotateLabelsSlider() {
        guard let slider = gainControlSlider else {return}

        if let minimumImage = slider.minimumValueImage {
            let minImage = UIImage(cgImage: minimumImage.cgImage!, scale: slider.minimumValueImage!.scale, orientation: .right)
            slider.minimumValueImage = minImage
        }

        if let maximumImage = slider.maximumValueImage {
            let maxImage = UIImage(cgImage: maximumImage.cgImage!, scale: slider.maximumValueImage!.scale, orientation: .right)
            slider.maximumValueImage = maxImage
        }
    }

}

import AVFoundation
extension InputSoundGainControlView {
    @IBAction func sliderValueChanged(_ sender: AnyObject) {
        eventHandler?.sliderValueHasChangedTo(gainControlSlider.value)
    }

    public func setInputSoundGainControlValue(_ value: Float) {
        gainControlSlider.value = value
    }
}
