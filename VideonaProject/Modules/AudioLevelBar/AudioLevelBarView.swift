//
//  AudioLevelBarView.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

public protocol AudioLevelBarDelegate {
    func audioLevelChange(_ value: Float)
}

@IBDesignable open class AudioLevelBarView: UIView, AudioLevelBarPresenterDelegate {
    // MARK: - VIPER
    var eventHandler: AudioLevelBarPresenterInterface?
    open var delegate: AudioLevelBarDelegate?

    // Our custom view from the XIB file
    var view: UIView!

    @IBOutlet weak var picometerImageView: UIImageView!
    @IBOutlet weak var audioLevelBar: UIProgressView!

    @IBInspectable var picometerImage: UIImage? {
        get {
            return picometerImageView.image
        }
        set(image) {
            picometerImageView?.image = image
        }
    }

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        // 1. setup any properties here

        // 2. call super.init(frame:)
        super.init(frame: frame)
        eventHandler = AudioLevelBarPresenter(controller: self)

        // 3. Setup view from .xib file
        xibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here

        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        eventHandler = AudioLevelBarPresenter(controller: self)

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
        let bundle = Bundle(for: AudioLevelBarView.self)

        let nib = UINib(nibName: "AudioLevelBarView", bundle: bundle)

        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    open func getAudioLevel() {
        eventHandler?.getAudioLevel()
    }

    open func setBarColor(_ color: UIColor) {
        audioLevelBar.progressTintColor = color
    }

    // MARK: presenter delegate
    func setAudioLevelToView(_ value: Float) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.audioLevelBar?.setProgress(value, animated: true)
        })

        delegate?.audioLevelChange(value)
    }
}
