//
//  BatteryRemainingInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

class BatteryRemainingInteractor: BatteryRemainingInteractorInterface {
    //MARK : VIPER
    var delegate: BatteryRemainingInteractorDelegate?

    init(presenter: BatteryRemainingPresenter) {
        UIDevice.current.isBatteryMonitoringEnabled = true

        delegate = presenter
        setUpBatteryListener()
    }

    func getBatteryUpdateValues() {
        getBatteryLevel()
        getEstimatedBatteryTime()
    }

    func getBatteryLevel() {
        let batteryLevel = (UIDevice.current.batteryLevel) * 100
        delegate?.setPercentValue(batteryLevel)
    }

    func getEstimatedBatteryTime() {
        let batteryLevel = (UIDevice.current.batteryLevel)

        let estimatedTimeCapturingVideoForFullBattery: Float = 4.0

        let timeLeft = batteryLevel*estimatedTimeCapturingVideoForFullBattery*3600

        let text = hourToString(Double(timeLeft))

        delegate?.setRemainingTimeText(text)
    }

    func hourToString(_ time: Double) -> String {
        let hours = Int(floor(time/3600))
        let mins = Int(floor(time.truncatingRemainder(dividingBy: 3600)) / 60)

        return String(format:"%02dh. %02dm.", hours, mins)
    }

    func setUpBatteryListener() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryLevelChanged),
            name: NSNotification.Name.UIDeviceBatteryLevelDidChange,
            object: nil)
    }

    @objc func batteryLevelChanged() {
        self.getBatteryUpdateValues()
    }
}
