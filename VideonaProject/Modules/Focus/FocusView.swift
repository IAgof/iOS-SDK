//
//  FocusView.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

public protocol FocusDelegate {
    func showFocusLens()
    func hideFocusLens()
    func showFocusAtPoint(_ point: CGPoint)
}

@IBDesignable public class FocusView: UIView, FocusPresenterDelegate {
    // MARK: - VIPER
    var eventHandler: FocusPresenterInterface?
    public  var delegate: FocusDelegate?

    // Our custom view from the XIB file
    var view: UIView!

    @IBOutlet weak var autoButton: UIButton!
    @IBOutlet weak var focalLensManualButton: UIButton!
    @IBOutlet weak var manualTapButton: UIButton!

    @IBInspectable var autoImageNormal: UIImage? {
        get {
            return autoButton.currentImage
        }
        set(autoImage) {
            autoButton.setImage(autoImage, for: UIControlState())
        }
    }

    @IBInspectable var autoImageHighlightedAndPressed: UIImage? {
        get {
            return autoButton.currentImage
        }
        set(autoImageHighlightedAndPressed) {
            autoButton.setImage(autoImageHighlightedAndPressed, for: .highlighted)
            autoButton.setImage(autoImageHighlightedAndPressed, for: .selected)
        }
    }

    @IBInspectable var focalLensManualImageNormal: UIImage? {
        get {
            return focalLensManualButton.currentImage
        }
        set(focalLensManualImage) {
            focalLensManualButton.setImage(focalLensManualImage, for: UIControlState())
        }
    }

    @IBInspectable var focalLensManualImageHighlightedAndPressed: UIImage? {
        get {
            return focalLensManualButton.currentImage
        }
        set(focalLensManualImageHighlightedAndPressed) {
            focalLensManualButton.setImage(focalLensManualImageHighlightedAndPressed, for: .highlighted)
            focalLensManualButton.setImage(focalLensManualImageHighlightedAndPressed, for: .selected)
        }
    }

    @IBInspectable var manualTapImageNormal: UIImage? {
        get {
            return manualTapButton.currentImage
        }
        set(manualTapImage) {
            manualTapButton.setImage(manualTapImage, for: UIControlState())
        }
    }

    @IBInspectable var manualTapImageHighlightedAndPressed: UIImage? {
        get {
            return manualTapButton.currentImage
        }
        set(manualTapImageHighlightedAndPressed) {
            manualTapButton.setImage(manualTapImageHighlightedAndPressed, for: .highlighted)
            manualTapButton.setImage(manualTapImageHighlightedAndPressed, for: .selected)
        }
    }

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        // 1. setup any properties here

        // 2. call super.init(frame:)
        super.init(frame: frame)
        eventHandler = FocusPresenter(controller: self)

        // 3. Setup view from .xib file
        xibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here

        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        eventHandler = FocusPresenter(controller: self)

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
        let bundle = Bundle(for: FocusView.self)

        let nib = UINib(nibName: "FocusView", bundle: bundle)

        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    // MARK: - Actions
    @IBAction func pushAutoFocus(_ sender: AnyObject) {
        setAutoFocus()
    }

    public func setAutoFocus() {
        eventHandler?.autoModePushed()
    }

    @IBAction func pushManualFocus(_ sender: AnyObject) {
        eventHandler?.manualModePushed()
    }

    @IBAction func pushFocalLensManual(_ sender: AnyObject) {
        eventHandler?.focusLensModePushed()
    }

    // MARK: - Delegate
    func showFocalLens() {
        delegate?.showFocusLens()
    }

    func hideFocalLens() {
        delegate?.hideFocusLens()
    }

    func setAutoButtonSelected(_ state: Bool) {
        autoButton.isSelected = state
    }

    func setTapManualButtonSelected(_ state: Bool) {
        manualTapButton.isSelected = state
    }

    func setFocalLensManualButtonSelected(_ state: Bool) {
        focalLensManualButton.isSelected = state
    }

    func sendFocusPoint(_ point: CGPoint) {
        delegate?.showFocusAtPoint(point)
    }

    // MARK: - Tap Action
    public func tapViewPointAndViewFrame(_ point: CGPoint,
                                  frame: CGRect) {
        eventHandler?.setFocusAtPoint(point,
                                      frame: frame)
    }

    public func checkIfFocalLensIsEnabled() {
        eventHandler?.checkFocalLensEnabled()
    }

}
