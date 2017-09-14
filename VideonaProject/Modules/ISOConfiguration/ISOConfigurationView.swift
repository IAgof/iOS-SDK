//
//  ISOConfigurationView.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

public protocol ISOConfigurationDelegate {
    func closeISOConfigurationPushed()
}

open class ISOConfigurationView: UIView, ISOConfigurationPresenterDelegate {
    // MARK: - VIPER
    var eventHandler: ISOConfigurationPresenterInterface?
    open var delegate: ISOConfigurationDelegate?

    // Our custom view from the XIB file
    var view: UIView!

    // MARK: - Outlet
    @IBOutlet weak var autoISOButton: UIButton!
    @IBOutlet weak var fiftyButton: UIButton!
    @IBOutlet weak var oneHundredButton: UIButton!
    @IBOutlet weak var twoHundredButton: UIButton!
    @IBOutlet weak var fourHundredButton: UIButton!
    @IBOutlet weak var maxISOButton: UIButton!

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        // 1. setup any properties here

        // 2. call super.init(frame:)
        super.init(frame: frame)
        eventHandler = ISOConfigurationPresenter(controller: self)

        // 3. Setup view from .xib file
        xibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here

        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        eventHandler = ISOConfigurationPresenter(controller: self)

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
        let bundle = Bundle(for: ISOConfigurationView.self)

        let nib = UINib(nibName: "ISOConfigurationView", bundle: bundle)

        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    @IBAction func autoISOButtonPushed(_ sender: AnyObject) {
        setAutoISO()
    }

    public func setAutoISO() {
        eventHandler?.autoISOPushed()
    }

    @IBAction func fiftyButtonPushed(_ sender: AnyObject) {
        eventHandler?.fiftyISOPushed()
    }

    @IBAction func oneHundredButtonPushed(_ sender: AnyObject) {
        eventHandler?.oneHundredISOPushed()
    }

    @IBAction func twoHundredButtonPushed(_ sender: AnyObject) {
        eventHandler?.twoHundredISOPushed()
    }

    @IBAction func fourHundredButtonPushed(_ sender: AnyObject) {
        eventHandler?.fourHundredISOPushed()
    }

    @IBAction func maxISOButtonPushed(_ sender: AnyObject) {
        eventHandler?.maxISOPushed()
    }

    // MARK: presenter delegate
    func deselectAllButtons() {
        autoISOButton.isSelected = false
        fiftyButton.isSelected = false
        oneHundredButton.isSelected = false
        twoHundredButton.isSelected = false
        fourHundredButton.isSelected = false
        maxISOButton.isSelected = false
    }

    func selectAutoButton() {
        autoISOButton.isSelected = true
    }

    func selectFiftyButton() {
        fiftyButton.isSelected = true
    }

    func selectOneHundredButton() {
        oneHundredButton.isSelected = true
    }

    func selectTwoHundredButton() {
        twoHundredButton.isSelected = true
    }

    func selectFourHundredButton() {
        fourHundredButton.isSelected = true
    }

    func selectMaxButton() {
        maxISOButton.isSelected = true
    }
}
