//
//  SpaceOnDiskView.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit
import MBCircularProgressBar

public protocol SpaceOnDiskDelegate {
    func closeSpaceOnDiskPushed()
    func memoryValuesUpdated(_ value: Float)
}

open class SpaceOnDiskView: UIView, SpaceOnDiskPresenterDelegate {
    // MARK: - VIPER
    var eventHandler: SpaceOnDiskPresenterInterface?
    open var delegate: SpaceOnDiskDelegate?

    // Our custom view from the XIB file
    var view: UIView!

    // MARK: - Outlet
    @IBOutlet weak var spaceProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var spaceLeftLabel: UILabel!

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        // 1. setup any properties here

        // 2. call super.init(frame:)
        super.init(frame: frame)
        eventHandler = SpaceOnDiskPresenter(controller: self)

        // 3. Setup view from .xib file
        xibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here

        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        eventHandler = SpaceOnDiskPresenter(controller: self)

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
        let bundle = Bundle(for: SpaceOnDiskView.self)

        let nib = UINib(nibName: "SpaceOnDiskView", bundle: bundle)

        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    @IBAction func closeWindowPushed(_ sender: AnyObject) {
        delegate?.closeSpaceOnDiskPushed()
    }

    open func updateValues() {
        eventHandler?.updateSpaceLeftLevel()
    }

    // MARK: presenter delegate
    func updateBarValue(_ value: CGFloat) {
        spaceProgressBar.value = value
        delegate?.memoryValuesUpdated(Float(value))
    }
    func updateBarColor(_ color: UIColor) {
        spaceProgressBar.progressColor = color
    }
    func updateTextSpaceLeft(_ text: String) {
        spaceLeftLabel.text = text
    }
}
