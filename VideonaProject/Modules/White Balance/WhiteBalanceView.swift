//
//  WhiteBalanceView.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

public protocol WhiteBalanceDelegate {
    func closeWhiteBalancePushed()
}

@IBDesignable open class WhiteBalanceView: UIView,WhiteBalancePresenterDelegate {
    //MARK: - VIPER
    var eventHandler: WhiteBalancePresenterInterface?
    open var delegate:WhiteBalanceDelegate?
    
    // Our custom view from the XIB file
    var view: UIView!
    
    //MARK: - Outlet
    @IBOutlet weak var autoButton: UIButton!
    @IBOutlet weak var cloudyButton: UIButton!
    @IBOutlet weak var daylightButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var fluorescentButton: UIButton!
    @IBOutlet weak var tungstenButton: UIButton!


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
    
    @IBInspectable var cloudyImageNormal: UIImage? {
        get {
            return cloudyButton.currentImage
        }
        set(cloudyImage) {
            cloudyButton.setImage(cloudyImage, for: UIControlState())
        }
    }
    
    @IBInspectable var cloudyImageHighlightedAndPressed: UIImage? {
        get {
            return cloudyButton.currentImage
        }
        set(cloudyImageHighlightedAndPressed) {
            cloudyButton.setImage(cloudyImageHighlightedAndPressed, for: .highlighted)
            cloudyButton.setImage(cloudyImageHighlightedAndPressed, for: .selected)
        }
    }
    
    @IBInspectable var daylightImageNormal: UIImage? {
        get {
            return daylightButton.currentImage
        }
        set(daylightImage) {
            daylightButton.setImage(daylightImage, for: UIControlState())
        }
    }
    
    @IBInspectable var daylightImageHighlightedAndPressed: UIImage? {
        get {
            return daylightButton.currentImage
        }
        set(daylightImageHighlightedAndPressed) {
            daylightButton.setImage(daylightImageHighlightedAndPressed, for: .highlighted)
            daylightButton.setImage(daylightImageHighlightedAndPressed, for: .selected)
        }
    }
    
    @IBInspectable var flashImageNormal: UIImage? {
        get {
            return flashButton.currentImage
        }
        set(flashImage) {
            flashButton.setImage(flashImage, for: UIControlState())
        }
    }
    
    @IBInspectable var flashImageHighlightedAndPressed: UIImage? {
        get {
            return flashButton.currentImage
        }
        set(flashImageHighlightedAndPressed) {
            flashButton.setImage(flashImageHighlightedAndPressed, for: .highlighted)
            flashButton.setImage(flashImageHighlightedAndPressed, for: .selected)
        }
    }
    
    @IBInspectable var fluorescentImageNormal: UIImage? {
        get {
            return fluorescentButton.currentImage
        }
        set(fluorescentImage) {
            fluorescentButton.setImage(fluorescentImage, for: UIControlState())
        }
    }
    
    @IBInspectable var fluorescentImageHighlightedAndPressed: UIImage? {
        get {
            return fluorescentButton.currentImage
        }
        set(fluorescentImageHighlightedAndPressed) {
            fluorescentButton.setImage(fluorescentImageHighlightedAndPressed, for: .highlighted)
            fluorescentButton.setImage(fluorescentImageHighlightedAndPressed, for: .selected)
        }
    }
    
    @IBInspectable var tungstenImageNormal: UIImage? {
        get {
            return tungstenButton.currentImage
        }
        set(tungstenImage) {
            tungstenButton.setImage(tungstenImage, for: UIControlState())
        }
    }
    
    @IBInspectable var tungstenImageHighlightedAndPressed: UIImage? {
        get {
            return tungstenButton.currentImage
        }
        set(tungstenImageHighlightedAndPressed) {
            tungstenButton.setImage(tungstenImageHighlightedAndPressed, for: .highlighted)
            tungstenButton.setImage(tungstenImageHighlightedAndPressed, for: .selected)
        }
    }
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        eventHandler = WhiteBalancePresenter(controller: self)

        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here

        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        eventHandler = WhiteBalancePresenter(controller: self)

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
        let bundle = Bundle(for: WhiteBalanceView.self)
        
        let nib = UINib(nibName: "WhiteBalanceView", bundle: bundle)

        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    @IBAction func autoButtonPushed(_ sender: AnyObject) {
        setAutoWB()
    }
    
    public func setAutoWB(){
        eventHandler?.autoPushed()
    }
    
    @IBAction func cloudyButtonPushed(_ sender: AnyObject) {
        eventHandler?.cloudyPushed()
    }
    
    @IBAction func daylightButtonPushed(_ sender: AnyObject) {
        eventHandler?.daylightPushed()
    }
    
    @IBAction func flashButtonPushed(_ sender: AnyObject) {
        eventHandler?.flashPushed()
    }
    
    @IBAction func fluorescentButtonPushed(_ sender: AnyObject) {
        eventHandler?.fluorescentPushed()
    }
   
    @IBAction func tungstenButtonPushed(_ sender: AnyObject) {
        eventHandler?.tungstenPushed()
    }
    
    //MARK: presenter delegate
    func deselectAllButtons() {
        autoButton.isSelected = false
        cloudyButton.isSelected = false
        daylightButton.isSelected = false
        flashButton.isSelected = false
        tungstenButton.isSelected = false
        fluorescentButton.isSelected = false
    }
    
    func selectAutoButton() {
        autoButton.isSelected = true
    }
    
    func selectCloudyButton() {
        cloudyButton.isSelected = true
    }
    
    func selectDaylightButton() {
        daylightButton.isSelected = true
    }
    
    func selectFlashButton() {
        flashButton.isSelected = true
    }
    
    func selectTungstenButton() {
        tungstenButton.isSelected = true
    }
    
    func selectFluorescentButton() {
        fluorescentButton.isSelected = true
    }
}
