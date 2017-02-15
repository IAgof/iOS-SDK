//
//  ExpositionModesView.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

public protocol ExpositionModesDelegate {
    func showExpositionSlider()
    func hideExpositionSlider()
    func showFocusAtPoint(_ point:CGPoint)
}

@IBDesignable open class ExpositionModesView: UIView {
    //MARK: - VIPER
    var eventHandler: ExpositionModesPresenterInterface?
    open var delegate:ExpositionModesDelegate?
    
    // Our custom view from the XIB file
    var view: UIView!
        
    @IBOutlet weak var autoButton: UIButton!
    @IBOutlet weak var manualSliderButton: UIButton!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var manualButton: UIButton!
    
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
    
    @IBInspectable var manualSliderImageNormal: UIImage? {
        get {
            return manualSliderButton.currentImage
        }
        set(manualSliderImage) {
            manualSliderButton.setImage(manualSliderImage, for: UIControlState())
        }
    }
    
    @IBInspectable var manualSliderImageHighlightedAndPressed: UIImage? {
        get {
            return manualSliderButton.currentImage
        }
        set(manualSliderImageHighlightedAndPressed) {
            manualSliderButton.setImage(manualSliderImageHighlightedAndPressed, for: .highlighted)
            manualSliderButton.setImage(manualSliderImageHighlightedAndPressed, for: .selected)
        }
    }
    
    @IBInspectable var centerImageNormal: UIImage? {
        get {
            return centerButton.currentImage
        }
        set(centerImage) {
            centerButton.setImage(centerImage, for: UIControlState())
        }
    }
    
    @IBInspectable var centerImageHighlightedAndPressed: UIImage? {
        get {
            return centerButton.currentImage
        }
        set(centerImageHighlightedAndPressed) {
            centerButton.setImage(centerImageHighlightedAndPressed, for: .highlighted)
            centerButton.setImage(centerImageHighlightedAndPressed, for: .selected)
        }
    }
    
    @IBInspectable var manualImageNormal: UIImage? {
        get {
            return manualButton.currentImage
        }
        set(manualImage) {
            manualButton.setImage(manualImage, for: UIControlState())
        }
    }
    
    @IBInspectable var manualImageHighlightedAndPressed: UIImage? {
        get {
            return manualButton.currentImage
        }
        set(manualImageHighlightedAndPressed) {
            manualButton.setImage(manualImageHighlightedAndPressed, for: .highlighted)
            manualButton.setImage(manualImageHighlightedAndPressed, for: .selected)
        }
    }
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        eventHandler = ExpositionModesPresenter(controller: self)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        eventHandler = ExpositionModesPresenter(controller: self)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
//        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        view.layer.cornerRadius = 4
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: ExpositionModesView.self)
        
        let nib = UINib(nibName: "ExpositionModesView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    //MARK: - Actions
    @IBAction func pushAutoExposure(_ sender: AnyObject) {
        setAutoExposure()
    }
    
    public func setAutoExposure(){
        eventHandler?.autoModePushed()
    }
    
    @IBAction func pushSliderExposure(_ sender: AnyObject) {
        eventHandler?.manualSliderPushed()
    }
    
    @IBAction func pushCenterExposure(_ sender: AnyObject) {
        eventHandler?.centerModePushed()
    }
    
    @IBAction func pushManualExposure(_ sender: AnyObject) {
        eventHandler?.manualModePushed()
    }
    
    //MARK: - Tap Action
    open func tapViewPointAndViewFrame(_ point:CGPoint,
                                  frame:CGRect){
        eventHandler?.setFocusAtPoint(point,
                                      frame: frame)
    }
    
    open func checkIfExposureManualSliderIsEnabled(){
        eventHandler?.checkIfHadToShowSlider()
    }
    
}

extension ExpositionModesView:ExpositionModesPresenterDelegate{
    func setAutoButtonSelected(_ state: Bool) {
        autoButton.isSelected = state
    }
    
    func setSliderManualButtonSelected(_ state: Bool) {
        manualSliderButton.isSelected = state
    }
    
    func setManualButtonSelected(_ state: Bool) {
        manualButton.isSelected = state
    }
    
    func setCenterButtonSelected(_ state: Bool) {
        centerButton.isSelected = state
    }
    
    func showExpositionSlider() {
        delegate?.showExpositionSlider()
    }
    
    func hideExpositionSlider() {
        delegate?.hideExpositionSlider()
    }
    func sendFocusPoint(_ point: CGPoint) {
        delegate?.showFocusAtPoint(point)
    }
}
