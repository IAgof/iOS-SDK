//
//  ResolutionsSelectorView.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

public protocol ResolutionsSelectorDelegate {
    func removeResolutionsView()
    func resolutionToChangeReceived(_ resolution: String)
}

@IBDesignable open class ResolutionsSelectorView: UIView, ResolutionsSelectorPresenterDelegate {
    // MARK: - VIPER
    var eventHandler: ResolutionsSelectorPresenterInterface?
    open var delegate: ResolutionsSelectorDelegate?
    var view: UIView!
    let resolutionsNibName = "ResolutionsSelectorCell"
    let reuseIdentifierCell = "resolutionsSelectorCell"
    @IBOutlet weak var resolutionsTableView: UITableView!
    @IBOutlet weak var resolutionsLabel: UILabel!
    var resolutions: [String] = [] {
        didSet {
            resolutionsTableView.reloadData()
        }
    }
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        eventHandler = ResolutionsSelectorPresenter(controller: self)
        xibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        eventHandler = ResolutionsSelectorPresenter(controller: self)
        xibSetup()
    }
    // MARK: - View Configuration
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        resolutionsTableView.delegate = self
        resolutionsTableView.dataSource = self
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        view.layer.cornerRadius = 4
        addSubview(view)
    }
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: ResolutionsSelectorView.self)
        let nib = UINib(nibName: "ResolutionsSelectorView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    func registerCellNib() {
        let bundle = Bundle(for: ResolutionsSelectorCell.self)
        let nib = UINib(nibName: resolutionsNibName, bundle: bundle)
        resolutionsTableView.register(nib, forCellReuseIdentifier: reuseIdentifierCell)
    }
    open override func awakeFromNib() {
        registerCellNib()
        resolutionsTableView.allowsSelection = false
        eventHandler?.getResolutions()
    }
    // MARK: - Actions outside module
    open func setResolutionAtInit(_ resolution: String) {
        eventHandler?.setResolutionAtInitEvent(resolution)
    }
    // MARK: - Delegate
    func setResolutionsTableList(_ list: [String]) {
        resolutions = list
    }
    func setResolutionSwitchState(_ position: Int,
                                  state: Bool) {
        let cell = resolutionsTableView
            .cellForRow(at: IndexPath(row: position, section: 0)) as? ResolutionsSelectorCell
        cell?.resolutionsSwitch?.isOn = state
    }
    func sendAVResolutionPressetToThirdParty(_ resolution: String) {
        delegate?.resolutionToChangeReceived(resolution)
    }
}

extension ResolutionsSelectorView:UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resolutions.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: reuseIdentifierCell, for: indexPath) as! ResolutionsSelectorCell
        cell.resolutionsLabel?.text = resolutions[indexPath.row]
        cell.resolutionsSwitch?.tag = indexPath.row
        cell.resolutionsSwitch?.addTarget(self, action: #selector(ResolutionsSelectorView.switchStateChanged(_:)), for: UIControlEvents.valueChanged)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    func switchStateChanged(_ sender: UIButton) {
        eventHandler?.switchResolutionStateChanged(sender.tag)
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventHandler?.switchResolutionStateChanged(indexPath.row)
    }
}
