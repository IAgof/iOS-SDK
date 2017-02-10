//
//  BatteryRemainingPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

open class BatteryRemainingPresenter:BatteryRemainingPresenterInterface,BatteryRemainingInteractorDelegate{
    //MARK : VIPER
    var delegate:BatteryRemainingPresenterDelegate
    var interactor:BatteryRemainingInteractorInterface?
    
    init(controller:BatteryRemainingView){
        delegate = controller
        interactor = BatteryRemainingInteractor(presenter: self)
    }
    
    func updateBatteryLevel() {
        interactor?.getBatteryUpdateValues()
    }
    
    //Interactor Delegate
    func setPercentValue(_ level: Float) {
        delegate.updateBarValue(CGFloat(level))
        self.updateBatteryLevelColor(level)
    }
    
    func setRemainingTimeText(_ text:String) {
        delegate.updateTextTimeLeft(text)
    }
    
    //MARK: - Inner function
    func updateBatteryLevelColor(_ level:Float){
        var color = UIColor.red
        
        switch level {
        case 0...20:
            color = UIColor.red
            break
        case 21...45:
            color = UIColor.yellow
            break
        case 45...100:
            color = UIColor.green
            break            
        default:
            color = UIColor.red
            break
        }
        
        delegate.updateBarColor(color)
    }
}
